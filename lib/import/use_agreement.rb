require 'import/base'

module Import
  class UseAgreement < Base
    SIMPLE_FIELDS = %w(
      title body required
    )

    def self.fetch(catalog, portal_id)
      import = ::Import::Entry.new(Portal.find(portal_id))
      
      Client.paged_results 'UseAgreements', Client.use_agreements_url(catalog) do |record|
        import.create(record)
      end
    end

    def initialize(portal)
      @portal = portal
    end

    def create(json = {})
      import = ImportItem.use_agreements.oid(json['id']).first_or_initialize
      import.importable ||= ::UseAgreement.new

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.importable.portal = @portal

      import.save
      unless import.importable.save
        puts "Error saving use agreement #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
