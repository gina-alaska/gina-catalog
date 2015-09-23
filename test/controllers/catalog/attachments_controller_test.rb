require 'test_helper'

class Catalog::AttachmentsControllerTest < ActionController::TestCase
  def test_show
    login_user(:portal_admin)
    Attachment.any_instance.stubs(:file).returns(OpenStruct.new(path: Rails.root.join('test/fixtures/geojson_test.json').to_s, name: 'bar'))

    @attachment = attachments(:geojson)

    get :show, entry_id: @attachment.entry, id: @attachment, format: :geojson
    assert_response :success
  end
end
