require 'test_helper'

class MapLayerTest < ActiveSupport::TestCase
  should belong_to(:entry)

  should validate_presence_of(:name)
  should ensure_length_of(:name).is_at_most(255)
  should validate_presence_of(:url)
  should ensure_length_of(:url).is_at_most(255)
  should ensure_length_of(:type).is_at_most(255)
  should ensure_length_of(:layers).is_at_most(255)
  should ensure_length_of(:projections).is_at_most(255)
end
