require "test_helper"

class ImportItemTest < ActiveSupport::TestCase

  def import_item
    @import_item ||= ImportItem.new
  end

  def test_valid
    assert import_item.valid?
  end

end
