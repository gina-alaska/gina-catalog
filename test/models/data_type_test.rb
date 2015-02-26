require 'test_helper'

class DataTypeTest < ActiveSupport::TestCase
  should validate_presence_of(:name)

  should validate_length_of(:name).is_at_most(255)
  should validate_length_of(:description).is_at_most(255)

  test 'check for deletable' do
    data_type = data_types(:no_associated_entry)
    assert data_type.deletable?, 'Data type is marked as undeletable when it should be deletable.'
  end

  test 'check for undeletable' do
    data_type = data_types(:one)
    data_type.entries << entries(:one)

    assert !data_type.deletable?, 'Data type is marked as deletable but it should not be'
  end
end
