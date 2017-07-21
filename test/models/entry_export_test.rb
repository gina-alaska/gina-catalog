require "test_helper"

class EntryExportTest < ActiveSupport::TestCase

  def entry_export
    @entry_export ||= EntryExport.new
  end

  def test_valid
    assert entry_export.valid?
  end

end
