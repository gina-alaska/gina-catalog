require 'test_helper'

class InvitationTest < ActiveSupport::TestCase

  should validate_presence_of(:name)
  should validate_presence_of(:email)  

end
