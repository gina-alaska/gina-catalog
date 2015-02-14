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
    task :agencies => :environment do
      require 'open-uri'
      agencies = JSON.load(open('http://glynx2-api.127.0.0.1.xip.io/agencies.json'))
      agencies.each do |agency_json|
        org = Organization.where(name: agency_json['name']).first_or_create do |o|
          %w{ acronym category description url }.each do |field|
            o.send("#{field}=", agency_json[field])
          end
          o.logo_url = agency_json['logo_url']
        end
      end
    end

    task :entries => :environment do
      require 'open-uri'
      catalogs = JSON.load(open('http://glynx2-api.127.0.0.1.xip.io/catalogs.json'))
      catalogs.each do |catalog_json|
        entry = Entry.includes(:import).where(import_items: { import_id: catalog_json['id'] }).first_or_create do |e|
          %w{ title description start_date end_date status }.each do |field|
            e.send("#{field}=", catalog_json[field])
          end
          e.entry_type = EntryType.where('name ilike ?', catalog_json['type'] ).first
          e.portals << Portal.first
        end
        puts entry.errors.full_messages
      end
    end
  end
end
