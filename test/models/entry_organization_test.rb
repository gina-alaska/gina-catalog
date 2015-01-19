require 'test_helper'

class EntryOrganizationTest < ActiveSupport::TestCase
  should belong_to(:entry)
  should belong_to(:organization)
end
