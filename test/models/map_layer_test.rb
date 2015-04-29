require 'test_helper'

class MapLayerTest < ActiveSupport::TestCase
  should have_many(:entry_map_layers)
  should have_many(:entries).through(:entry_map_layers)

  should belong_to(:portal)

  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_most(255)
  should validate_presence_of(:map_url)
  should validate_length_of(:map_url).is_at_most(255)
  should validate_length_of(:type).is_at_most(255)
  should validate_length_of(:layers).is_at_most(255)
  should validate_length_of(:projections).is_at_most(255)

  test 'EPSG:33338 projection should be supported' do
    map_layer = map_layers(:one)

    assert map_layer.supports?('EPSG:3338'), 'projection is not supported when it should be.'
  end

  test 'EPSG:3572 projection should not be supported' do
    map_layer = map_layers(:one)

    assert_not map_layer.supports?('EPSG:3572'), 'projection is supported when it should not be.'
  end
end
