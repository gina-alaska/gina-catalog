require 'test_helper'

class EntryMapLayerTest < ActiveSupport::TestCase
  should belong_to :entry
  should belong_to :map_layer

  def entry_map_layer
    @entry_map_layer ||= EntryMapLayer.new
  end

  def test_valid
    assert entry_map_layer.valid?
  end
end
