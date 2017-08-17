require 'test_helper'

class EntrySearchConcernsTest < ActiveSupport::TestCase
  setup do
    @entry = entries(:one)
  end

  test 'should get list of collection names' do
    assert_includes @entry.text_search_fields, 'alaska'
  end

  test 'get a list of organization categories' do
    assert_includes @entry.text_search_fields, 'academic'
  end

  test 'should get list of organization names' do
    assert_includes @entry.text_search_fields, 'geographic information network alaska'
  end

  test 'should get entry type name' do
    assert_equal 'Project', @entry.entry_type_name
  end

  test 'should define search_import scope' do
    assert Entry.respond_to?(:search_import)
  end

  test 'search_data call search_data_with_entries' do
    assert_equal @entry.search_data_with_entries, @entry.search_data
  end
end
