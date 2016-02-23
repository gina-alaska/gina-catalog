require 'import/base'

module Import
  class Page < Base
    SIMPLE_FIELDS = %w(
      title slug content redirect_url draft hidden
    )

    def self.fetch(catalog, portal_id)
      import = new(Portal.find(portal_id))

      Client.results 'Layout', Client.pages_url(catalog) do |record|
        import.create(record)
      end
    end

    def initialize(portal)
      @portal = portal
      @portal.pages.destroy_all
    end

    def create(json = {})
      import = ImportItem.pages.oid(json['id']).first_or_initialize
      import.importable ||= ::Cms::Page.new

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.importable.portal = @portal
      parent = ImportItem.pages.oid(json['parent_id']).first.try(:importable)
      import.importable.parent = parent unless parent.nil?

      layout = ImportItem.layouts.oid(json['page_layout_id']).first.try(:importable)
      import.importable.cms_layout = layout unless layout.nil?

      import.save
      unless import.importable.save(validate: false)
        puts "Error saving page #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
