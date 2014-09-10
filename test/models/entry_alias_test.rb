require 'test_helper'

class EntryAliasTest < ActiveSupport::TestCase
  should ensure_length_of(:slug).is_at_most(255)
end
