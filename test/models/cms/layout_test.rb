require "test_helper"

class Cms::LayoutTest < ActiveSupport::TestCase

  def layout
    @layout ||= Cms::Layout.new
  end

  def test_valid
    assert layout.valid?
  end

end
