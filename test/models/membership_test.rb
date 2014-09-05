require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should validate_presence_of(:email)
end
