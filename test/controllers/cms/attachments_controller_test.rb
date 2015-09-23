require "test_helper"

class Cms::AttachmentsControllerTest < ActionController::TestCase

  def cms_attachment
    @cms_attachment ||= cms_attachments :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cms_attachments)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Cms::Attachment.count') do
      post :create, cms_attachment: { description: cms_attachment.description, file: 'test/fixtures/cms/attachments.yml', name: cms_attachment.name }
    end

    assert_redirected_to cms_attachment_path(assigns(:cms_attachment))
  end

  def test_show
    get :show, id: cms_attachment
    assert_response :success
  end

  def test_edit
    get :edit, id: cms_attachment
    assert_response :success
  end

  def test_update
    put :update, id: cms_attachment, cms_attachment: { description: cms_attachment.description, file_content_type: cms_attachment.file_content_type, file_filename: cms_attachment.file_filename, file_id: cms_attachment.file_id, file_size: cms_attachment.file_size, name: cms_attachment.name, portal_id: cms_attachment.portal_id }
    assert_redirected_to cms_attachment_path(assigns(:cms_attachment))
  end

  def test_destroy
    assert_difference('Cms::Attachment.count', -1) do
      delete :destroy, id: cms_attachment
    end

    assert_redirected_to cms_attachments_path
  end
end
