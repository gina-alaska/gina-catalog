require 'test_helper'

class AgencyContactTest < ActiveSupport::TestCase
  should belong_to(:contact)
  should belong_to(:agency)
end
