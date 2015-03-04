require 'test_helper'

class Manager::AttachmentsControllerTest < ActionController::TestCase
  def test_show
    login_user(:portal_admin)

    @attachment = attachments(:one)

    xhr :get, :show, entry_id: @attachment.entry, id: @attachment
    assert_response :success
  end
end
