require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  should validate_length_of(:name).is_at_most(255)

  should belong_to(:portal)
  should have_many(:entry_collections)
  should have_many(:entries).through(:entry_collections)

  test 'on create the entry_collections_count should be zero' do
    collection = Collection.create(name: 'Testing', description: 'test')

    assert_equal 0, collection.entry_collections_count
  end
end
