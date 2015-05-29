require 'test_helper'

class EntryAliasTest < ActiveSupport::TestCase
  should validate_length_of(:slug).is_at_most(255)
end
