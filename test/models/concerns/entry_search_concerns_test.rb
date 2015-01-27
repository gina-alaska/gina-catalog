require 'test_helper'

class EntrySearchConcernsTest < ActiveSupport::TestCase
  setup do
    @entry = entries(:one)
  end

  test "should get list of collection names" do
    assert_equal ['Alaska'], @entry.collection_names
  end

  test "get a list of organization categories" do
    assert_equal ['Academic'], @entry.organization_categories
  end

  test "should get list of organization names with acronyms" do
    assert_equal ['Geographic Information Network of Alaska GINA'], @entry.organization_name
  end

  test "should get entry type name" do
    assert_equal 'Project', @entry.entry_type_name
  end

  test "should define search_import scope" do
    assert Entry.respond_to?(:search_import)
  end

  test "search_data call search_data_with_entries" do
    assert_equal @entry.search_data_with_entries, @entry.search_data
  end
end
