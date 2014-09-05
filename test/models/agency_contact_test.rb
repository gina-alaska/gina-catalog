require 'test_helper'

class AgencyContactTest < ActiveSupport::TestCase
  should belong_to(:contact)
end
