require 'test_helper'

class ActivityLogTest < ActiveSupport::TestCase
  should belong_to(:loggable)
  should belong_to(:entry)
  should belong_to(:portal)
  should belong_to(:user)

  should validate_length_of(:activity).is_at_most(255)
  should validate_length_of(:loggable_type).is_at_most(255)
  should validate_presence_of(:activity)
end
