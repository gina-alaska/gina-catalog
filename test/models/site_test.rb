require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
  should validate_presence_of(:acronym)
  
  should have_many(:urls)
  
  should accept_nested_attributes_for(:urls).allow_destroy(true)
  
  def setup
    @site = sites(:one)
  end
  
  test "default_url should return the default url" do
    assert_equal @site.default_url.url, 'catalog.192.168.222.225.xip.io'
  end
end
