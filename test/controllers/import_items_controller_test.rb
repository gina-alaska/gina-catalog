require "test_helper"

class ImportItemsControllerTest < ActionController::TestCase
  def setup
    @import_item = import_items(:one)
  end

  def test_entries
    get :entries, id: @import_item.import_id

    assert_redirected_to entry_path(@import_item.importable)
  end

  def test_download
    # enable and/or fix this when attachments are added
    # get :downloads, id: @import_item.import_id, uuid: @import_item.importable.uuid

    # assert_redirected_to attachment_path(@import_item.importable.uuid)
  end
end
