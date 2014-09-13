require 'test_helper'

class SiteNotFoundFlowsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "invalid site host should redirect to site_not_found" do
    host! "test.192.168.222.225.xip.io"
    get_via_redirect '/'
    assert_equal '/site_not_found', path
  end
  
  test "valid site host should not redirect to site_not_found" do
    host! "catalog.192.168.222.225.xip.io"
    get '/'
    assert_equal '/', path
  end
  
  test "valid site request to site_not_found should redirect to root" do
    host! "catalog.192.168.222.225.xip.io"
    get_via_redirect '/site_not_found'
    assert_equal '/', path
  end
end
