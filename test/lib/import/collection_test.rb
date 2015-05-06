require 'test_helper'
require 'import'

class Import::CollectionTest < ActiveSupport::TestCase
  test 'should create valid collection' do
    collection_import = Import::Collection.new(portals(:one))
    import = collection_import.create(
      'id' => 2,
      'name' => 'Collection',
      'description' => 'Description test.',
    )
    assert import.importable.valid?, import.importable.errors.full_messages
  end
end