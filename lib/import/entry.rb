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

      import.importable.portals << @portal

      import.save
      import.importable.save
      import
    end

    def entry_type(name)
      EntryType.where('name ilike :name', name: name).first
    end

    def add_orgs(model, json)
      model.primary_organizations << find_org(json['primary_agency']) if json['primary_agency'].present?
      model.funding_organizations << find_org(json['funding_agency']) if json['funding_agency'].present?
      json['agencies'].each do |agency|
        model.organizations << find_org(agency)
      end if json['agencies'].present?
    end

    def add_contacts(model, json = {})
      model.primary_contacts << find_contact(json['primary_contact']) if json['primary_contact'].present?

      json['contacts'].each do |contact|
        model.contacts << find_contact(contact)
      end if json['contacts'].present?
    end

    def add_locations(record, locations)
      return if !locations.present? or locations.to_json.blank?

      begin
        tf = Tempfile.new(['locations', '.geojson'])

        tf << locations.to_json

        attachment = record.attachments.where(description: 'gLynx locations').first_or_initialize do |a|
          a.category = 'Geojson'
          a.file = tf
        end
        record.attachments << attachment if attachment.new_record?
        attachment.save
      ensure
        tf.close
        tf.unlink
      end
    end
  end
end
