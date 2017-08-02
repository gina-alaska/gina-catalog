require 'import/base'

module Import
  class Entry < Base
    attr_accessor :errors

    SIMPLE_FIELDS = %w(
      title description start_date end_date status
      tag_list entry_type primary_organization_ids funding_organization_ids
      primary_contact_ids published_at
    )

    def self.fetch(catalog, portal_id)
      import = ::Import::Entry.new(Portal.find(portal_id))

      Client.paged_results('Entries', Client.catalog_records_url(catalog), ENV['page'].to_i) do |record|
        import.create(record)
      end

      unless import.errors.nil? || import.errors.empty?
        puts import.errors.inspect
        puts "Error importing #{import.errors.count} records"
      end
    end

    def initialize(portal)
      @portal = portal
    end

    def create(json = {})
      import = ImportItem.entries.oid(json['id']).first_or_initialize
      import.importable ||= ::Entry.new

      json['entry_type'] = entry_type(json['type'])

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)
      %w( orgs locations contacts collections regions iso_topics use_agreement links data_types archive_info attachments).each do |topic|
        send(:"add_#{topic}", import.importable, json)
      end

      import.importable.portals << @portal unless import.importable.portals.include?(@portal)
      import.importable.status ||= 'Unknown'
      import.importable.description ||= 'Empty'

      import.save
      unless import.importable.save
        @errors ||=[]
        @errors << [import.import_id, import.importable.errors]
        puts "Error saving entry #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end

    def entry_type(name)
      EntryType.where('name ilike :name', name: name).first
    end

    def add_attachments(model, json = {})
      json['uploads'].each do |upload|
        attachment = model.attachments.where(file_name: upload['name']).first_or_initialize do |a|
          if upload['preview']
            if model.primary_thumbnail_count == 0
              a.category = 'Primary Thumbnail'
            else
              a.category = 'Thumbnail'
            end
          elsif upload['downloadable']
            a.category = 'Public Download'
          else
            a.category = 'Private Download'
          end

          a.file_url = upload['url']
          a.file_name = upload['name']
          a.description = upload['description']
        end

        model.attachments << attachment unless model.attachments.include?(attachment)
        attachment.save
      end if json['uploads'].present?
    end

    def add_primary_org(model, org)
      return if org.nil? || model.primary_organizations.include?(org)
      model.primary_organizations << org
    end

    def add_funding_org(model, org)
      return if org.nil? || model.funding_organizations.include?(org)
      model.funding_organizations << org
    end

    def add_orgs(model, json)
      add_primary_org model, find_org(json['primary_agency']) if json['primary_agency'].present?
      add_funding_org model, find_org(json['funding_agency']) if json['funding_agency'].present?

      json['agencies'].each do |agency|
        org =  find_org(agency)
        next if model.organizations.include?(org)
        model.organizations << org
      end if json['agencies'].present?
    end

    def add_contacts(model, json = {})
      pcontact = find_contact(json['primary_contact']) if json['primary_contact'].present?
      model.primary_contacts << pcontact unless pcontact.nil? || model.primary_contacts.include?(pcontact)

      json['contacts'].each do |contact|
        contact = find_contact(contact)
        model.contacts << contact unless contact.nil? || model.contacts.include?(contact)
      end if json['contacts'].present?
    end

    def add_regions(model, json = {})
      json['regions'].each do |region|
        item = find_region(region)
        model.regions << item unless item.nil? || model.regions.include?(item)
      end if json['regions'].present?
    end

    def add_iso_topics(model, json)
      json['iso_topics'].each do |iso_topic|
        item =  find_iso_topic(iso_topic)
        next if model.iso_topics.include?(item)
        model.iso_topics << item
      end if json['iso_topics'].present?
    end

    def add_data_types(model, json = {})
      json['data_types'].each do |data_type|
        item = find_data_type(data_type)
        model.data_types << item unless item.nil? || model.data_types.include?(item)
      end if json['data_types'].present?
    end

    def add_collections(model, json = {})
      json['collections'].each do |collection|
        collection = find_collection(collection)
        model.collections << collection unless collection.nil? || model.collections.include?(collection)
      end if json['collections'].present?
    end

    def add_use_agreement(model, json = {})
      item = find_use_agreement(json['use_agreement']) if json['use_agreement'].present?
      model.use_agreement = item unless item.nil? || model.use_agreement.present?
    end

    def add_locations(record, json = {})
      locations = json['locations']
      return if !locations.present? || locations.to_json.blank?
      return if locations['features'].empty?

      begin
        tf = Tempfile.new(['locations', '.geojson'])

        tf << locations.to_json

        attachment = record.attachments.where(description: 'gLynx locations').first_or_initialize do |a|
          a.category = 'Geojson'
          a.file = tf
          a.file_name = 'imported_locations'
        end
        record.attachments << attachment if attachment.new_record?
        attachment.save
      ensure
        tf.close
        tf.unlink
      end
    end

    def add_links(record, json)
      return unless json['links'].present?
      json['links'].each do |link|
        link.delete('id')
        next if record.links.where(url: link['url']).count > 0
        record.links.build(link)
      end
    end

    def add_archive_info(record, json)
      return if json['archived_at'].blank?
      record.archive!('No archive message available', nil)
    end
  end
end
