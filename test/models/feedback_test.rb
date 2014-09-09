require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  should ensure_length_of(:name).is_at_most(255)
  should ensure_length_of(:email).is_at_most(255)
  should validate_numericality_of(:user_id).only_integer
  should validate_numericality_of(:site_id).only_integer
end
