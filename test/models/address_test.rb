require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  should ensure_length_of(:line1).is_at_most(255)
  should ensure_length_of(:line2).is_at_most(255)
  should ensure_length_of(:country).is_at_most(255)
  should ensure_length_of(:state).is_at_most(255)
  should ensure_length_of(:city).is_at_most(255)
  should ensure_length_of(:zipcode).is_at_most(255)
  should ensure_length_of(:addressable_type).is_at_most(255)
end
