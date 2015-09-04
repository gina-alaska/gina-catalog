require "test_helper"

class Cms::PageTest < ActiveSupport::TestCase

  def page
    @page ||= Cms::Page.new
  end

  def test_valid
    assert page.valid?
  end

end
