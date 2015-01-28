require 'test_helper'

class EntryTypeTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:color)

  should ensure_length_of(:name).is_at_most(255)
  should ensure_length_of(:description).is_at_most(255)
  should ensure_length_of(:color).is_at_most(255)

  should have_many(:entries)

  test 'check for deletable' do
    entry_type = entry_types(:no_associated_entry)
    assert entry_type.deletable?, 'Entry type is marked as undeletable when it should be deletable.'
  end

  test 'check for undeletable' do
    entry_type = entry_types(:one)
    entry_type.entries << entries(:one)

    assert !entry_type.deletable?, 'Catalog type is marked as deletable but it should not be'
  end
end
