require "test_helper"

class Cms::ThemeTest < ActiveSupport::TestCase

  def theme
    @theme ||= Cms::Theme.new
  end

  def test_valid
    assert theme.valid?
  end

end
