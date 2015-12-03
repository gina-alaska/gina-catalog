require 'test_helper'

class PortalUrlTest < ActiveSupport::TestCase
  should belong_to('portal')

  test 'should return the active url' do
    assert_not PortalUrl.find_active_url('test.host').nil?, 'Could not find the specified active url'
  end
end
