require 'import/base'

module Import
  class Snippet < Base
    SIMPLE_FIELDS = %w(
      name content
    )

    def self.fetch(catalog, portal_id)
      import = new(Portal.find(portal_id))

      Client.results 'Layout', Client.snippets_url(catalog) do |record|
        import.create(record)
      end
    end

    def initialize(portal)
      @portal = portal
    end

    def create(json = {})
      import = ImportItem.snippets.oid(json['id']).first_or_initialize
      import.importable ||= ::Cms::Snippet.new

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.importable.portal = @portal

      import.save
      unless import.importable.save(validate: false)
        puts "Error saving snippet #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
