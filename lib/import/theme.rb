require 'import/base'

module Import
  class Theme < Base
    SIMPLE_FIELDS = %w(
      name css
    )

    def self.fetch(catalog, portal_id)
      import = new(Portal.find(portal_id))

      Client.results 'Layout', Client.themes_url(catalog) do |record|
        import.create(record)
      end
    end

    def initialize(portal)
      @portal = portal
    end

    def create(json = {})
      import = ImportItem.themes.oid(json['id']).first_or_initialize
      import.importable ||= ::Cms::Theme.new

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.importable.portal = @portal

      import.save
      unless import.importable.save
        puts "Error saving theme #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
