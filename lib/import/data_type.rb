require 'import/base'

module Import
  class DataType < Base
    SIMPLE_FIELDS = %w(
      name description
    )

    def self.fetch
      import = ::Import::DataType.new
      Client.results 'DataTypes', Client.data_types_url do |record|
        import.create(record)
      end
    end


    def create(json = {})
      import = ImportItem.data_types.oid(json['id']).first_or_initialize
      import.importable ||= ::DataType.new
      
      add_simple_fields(SIMPLE_FIELDS, import.importable, json)

      import.save
      unless import.importable.save
        puts "Error saving data type #{import.import_id}"
        puts import.importable.errors.full_messages
      end
      import
    end
  end
end
