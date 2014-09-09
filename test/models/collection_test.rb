require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  should ensure_length_of(:name).is_at_most(255)
  should validate_numericality_of(:site_id).only_integer
end
