require 'test_helper'

class ArchiveItemTest < ActiveSupport::TestCase
  def archive_item
    @archive_item ||= ArchiveItem.new
  end

  def test_valid
    assert archive_item.valid?
  end
end
