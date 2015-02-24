require 'test_helper'

class DataTypeTest < ActiveSupport::TestCase
  should validate_presence_of(:name)

  should validate_length_of(:name).is_at_most(255)
  should validate_length_of(:description).is_at_most(255)
end
