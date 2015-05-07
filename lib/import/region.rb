require 'import/base'

module Import
  class Region < Base
    SIMPLE_FIELDS = %w(
      name geom
    )
    
    def self.fetch
      region = ::Import::Region.new

      Client.paged_results 'Regions', Client.regions_url do |json|
        region.create(json)
      end
    end

    def create(json = {})
      import = ImportItem.regions.oid(json['id']).first_or_initialize
      import.importable ||= ::Region.where(name: json['name']).first_or_initialize

      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.save
      unless import.importable.save
        puts "Error saving region #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
