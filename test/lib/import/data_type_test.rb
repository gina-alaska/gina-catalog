require 'test_helper'
require 'import'

class Import::DataTypeTest < ActiveSupport::TestCase
  test 'should create valid data type' do
    data_type_import = Import::DataType.new
    import = data_type_import.create(
      'id' => 3,
      'name' => 'Database',
      'description' => 'Database test'
    )
    assert import.importable.valid?, import.importable.errors.full_messages
  end
end
