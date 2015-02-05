require 'test_helper'

class PortalNotFoundFlowsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test 'invalid portal host should redirect to portal_not_found' do
    host! 'test.192.168.222.225.xip.io'
    get_via_redirect '/'
    assert_equal '/portal_not_found', path
  end

  test 'valid portal host should not redirect to portal_not_found' do
    host! 'catalog.192.168.222.225.xip.io'
    get '/'
    assert_equal '/', path
  end

  test 'valid portal request to portal_not_found should redirect to root' do
    host! 'catalog.192.168.222.225.xip.io'
    get_via_redirect '/portal_not_found'
    assert_equal '/', path
  end
end
