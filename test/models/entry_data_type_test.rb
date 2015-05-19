require 'test_helper'

class EntryDataTypeTest < ActiveSupport::TestCase
  def entry_data_type
    @entry_data_type ||= EntryDataType.new
  end

  def test_valid
    assert entry_data_type.valid?
  end
end
