require 'import/base'

module Import
  class Attachment < Base
    SIMPLE_FIELDS = %w(
      name description file_filename
    )

    def self.fetch(catalog, portal_id)
      import = new(Portal.find(portal_id))

      Client.results 'Attachment', Client.attachments_url(catalog) do |record|
        import.create(record)
      end
    end

    def initialize(portal)
      @portal = portal
    end

    def create(json = {})
      import = ImportItem.attachments.oid(json['id']).first_or_initialize
      import.importable ||= ::Cms::Attachment.new

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)
      import.importable.remote_file_url = json['url']
      import.importable.portal = @portal

      import.save
      unless import.importable.save
        puts "Error saving attachment #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
