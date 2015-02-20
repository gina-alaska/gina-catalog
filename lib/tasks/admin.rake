namespace :admin do
  desc 'Set user to global admin'
  task :set, [:email] => :environment do |_t, args|
    email = args[:email]
    if email.blank?
      puts "Usage: rake \"admin:set[user@email.com]\""
      exit 1
    end

    user = User.where(email: email).first

    if user.nil?
      puts "Could not find user with email: #{email}"
      exit 1
    end

    Portal.all.each do |portal|
      permission = user.permissions.where(portal: portal).first_or_initialize
      permission.roles = { cms_manager: true, data_manager: true, portal_manager: true }
      permission.save
    end

    if user.update_attribute(:global_admin, true)
      puts "Succesfully set #{email} as global admin"
    else
      puts 'There was an error trying to set the user as a global admin'
    end
  end

  namespace :load do
    desc 'Load agencies from api'
    task agencies: :environment do
      require 'open-uri'
      agencies = JSON.load(open('http://glynx2-api.127.0.0.1.xip.io/agencies.json'))
      agencies.each do |agency_json|
        Organization.where(name: agency_json['name']).first_or_create do |o|
          %w(acronym category description url).each do |field|
            o.send("#{field}=", agency_json[field])
          end
          o.logo_url = agency_json['logo_url']
        end
      end
    end

    def fetch_catalog_records(page)
      JSON.load(open("http://glynx2-api.127.0.0.1.xip.io/catalogs.json?page=#{page}"))
    end

    def entry_type(name)
      EntryType.where('name ilike :name', name: name).first
    end

    def add_primary_org(record, agency)
      return if agency.nil?

      org = Organization.where(name: agency['name']).first
      record.primary_organizations << org unless org.nil? || record.primary_organizations.include?(org)
    end

    def add_funding_org(record, agency)
      return if agency.nil?

      org = Organization.where(name: agency['name']).first
      record.funding_organizations << org unless org.nil? || record.funding_organizations.include?(org)
    end

    def add_other_orgs(record, agencies)
      agencies.each do |json|
        org = Organization.where(name: json['name']).first
        record.organizations << org unless org.nil? || record.organizations.include?(org)
      end
    end

    def import_record(portal, json)
      import = ImportItem.where(import_id: json['id']).first_or_initialize
      import.importable ||= Entry.new

      %w(title description start_date end_date status tag_list).each do |field|
        import.importable.send("#{field}=", json[field])
      end
      import.importable.entry_type = entry_type(json['type'])
      import.importable.portals << portal unless import.importable.portals.include?(portal)

      add_primary_org(import.importable, json['primary_agency'])
      add_funding_org(import.importable, json['funding_agency'])
      add_other_orgs(import.importable, json['agencies'])

      import.save
      import.importable.save
    end

    task entries: :environment do
      require 'open-uri'
      portal = Portal.first
      page = 1
      while (catalogs = get_catalog_records(page))
        puts "Processing page #{page} - #{catalogs.count}"
        page += 1
        catalogs.each { |json| import_record(portal, json) }
      end
    end
  end
end
