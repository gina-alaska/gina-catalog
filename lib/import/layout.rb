require 'import/base'

module Import
  class Layout < Base
    SIMPLE_FIELDS = %w(
      name content
    )

    def self.fetch(catalog, portal_id)
      import = new(Portal.find(portal_id))

      Client.results 'Layout', Client.layouts_url(catalog) do |record|
        import.create(record)
      end
    end

    def initialize(portal)
      @portal = portal
    end

    def create(json = {})
      import = ImportItem.layouts.oid(json['id']).first_or_initialize
      import.importable ||= ::Cms::Layout.new

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.importable.portal = @portal

      import.save
      unless import.importable.save
        puts "Error saving layout #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
