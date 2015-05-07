require 'import/base'

module Import
  class Entry < Base
    SIMPLE_FIELDS = %w(
      title description start_date end_date status
      tag_list entry_type primary_organization_ids funding_organization_ids
      primary_contact_ids
    )

    def self.fetch(catalog)
      import = ::Import::Entry.new(Portal.first)

      Client.paged_results 'Entries', Client.catalog_records_url(catalog) do |record|
        import.create(record)
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
      add_orgs(import.importable, json)
      add_locations(import.importable, json['locations'])
      add_contacts(import.importable, json)
      add_collections(import.importable, json)
      add_regions(import.importable, json)      
      add_iso_topics(import.importable, json)
      add_use_agreement(import.importable, json)
      add_links(import.importable, json)

      import.importable.portals << @portal

      import.save
      unless import.importable.save
        puts "Error saving entry #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end

    def entry_type(name)
      EntryType.where('name ilike :name', name: name).first
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

    def add_locations(record, locations)
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
        next if !record.new_record? && record.links.where(url: link['url']).count > 0
        record.links.build(link)
      end
    end
  end
end
