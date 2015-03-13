require "test_helper"

class MapLayerTest < ActiveSupport::TestCase
  should belong_to(:entry)
  
  validates :name, presence: true
  validates :url, presence: true

  def map_layer
    @map_layer ||= MapLayer.new
  end

  def test_valid
    assert map_layer.valid?
  end

end
