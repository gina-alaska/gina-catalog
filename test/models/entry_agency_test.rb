require 'test_helper'

class EntryAgencyTest < ActiveSupport::TestCase
  should validate_numericality_of(:entry_id).only_integer
  should validate_numericality_of(:agency_id).only_integer
end
