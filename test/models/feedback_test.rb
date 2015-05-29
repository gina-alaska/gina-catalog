require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  should validate_length_of(:name).is_at_most(255)
  should validate_length_of(:email).is_at_most(255)
end
