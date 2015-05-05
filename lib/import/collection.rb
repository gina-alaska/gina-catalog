require 'import/base'

module Import
  class Collection < Base
    SIMPLE_FIELDS = %w(
      name description
    )

    def self.fetch(catalog)
      import = ::Import::Collection.new(Portal.first)
      Client.paged_results 'Collections', Client.collections_url(catalog) do |record|
        import.create(record)
      end
    end

    def initialize(portal)
      @portal = portal
    end

    def create(json = {})
      import = ImportItem.collections.oid(json['id']).first_or_initialize
      import.importable ||= ::Collection.new

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.importable.portal = @portal

      import.save
      unless import.importable.save
        puts "Error saving collection #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
