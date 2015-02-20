require "test_helper"

class DataTypeTest < ActiveSupport::TestCase

  def data_type
    @data_type ||= DataType.new
  end

  def test_valid
    assert data_type.valid?
  end

end
