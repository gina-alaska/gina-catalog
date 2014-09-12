require 'test_helper'

class SiteUserTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:site)
end
