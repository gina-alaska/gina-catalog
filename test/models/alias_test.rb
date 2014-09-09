require 'test_helper'

class AliasTest < ActiveSupport::TestCase
  should ensure_length_of(:text).is_at_most(255)
  should ensure_length_of(:aliasable_type).is_at_most(255)
  should validate_numericality_of(:aliasable_id).only_integer
end
