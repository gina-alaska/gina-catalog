require 'test_helper'

class EntryAgencyTest < ActiveSupport::TestCase
  should belong_to(:entry)
  should belong_to(:agency)
end
