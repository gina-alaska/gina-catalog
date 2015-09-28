require "test_helper"

class Cms::AttachmentsControllerTest < ActionController::TestCase
  setup do
    @cms_attachment = cms_attachments(:one)
    login_user(:admin)
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
      post :create, cms_attachment: {
        description: @cms_attachment.description,
        file: 'test/fixtures/cms/attachments.yml',
        name: @cms_attachment.name
      }
    end

    assert_redirected_to cms_attachment_path(assigns(:cms_attachment))
  end

  def test_show
    get :show, id: @cms_attachment
    assert_response :success
  end

  def test_edit
    get :edit, id: @cms_attachment
    assert_response :success
  end

  def test_update
    put :update, id: @cms_attachment, cms_attachment: {
      description: @cms_attachment.description,
      file: 'test/fixtures/cms/attachments.yml',
      name: @cms_attachment.name
    }

    assert_redirected_to cms_attachment_path(assigns(:cms_attachment))
  end

  def test_destroy
    assert_difference('Cms::Attachment.count', -1) do
      delete :destroy, id: @cms_attachment
    end

    assert_redirected_to cms_attachments_path
  end

  test "shouldn't move top attachment up" do
    @page = cms_pages(:home)
    @request.env['HTTP_REFERER'] = cms_page_path(@page)

    assert_difference("Cms::PageAttachment.where(attachment_id: #{@cms_attachment.id}).first.position", 0) do
      patch :up, page_id: @page, id: @cms_attachment
    end
  end

  test "should move attachment up" do
    @page = cms_pages(:home)
    @cms_attachment = cms_attachments(:two)
    @request.env['HTTP_REFERER'] = cms_page_path(@page)

    assert_difference("Cms::PageAttachment.where(attachment_id: #{@cms_attachment.id}).first.position", -1) do
      patch :up, page_id: @page, id: @cms_attachment
    end
  end

  test "shouldn't move bottom attachment down" do
    @page = cms_pages(:home)
    @cms_attachment = cms_attachments(:two)
    @request.env['HTTP_REFERER'] = cms_page_path(@page)

    assert_difference("Cms::PageAttachment.where(attachment_id: #{@cms_attachment.id}).first.position", 0) do
      patch :down, page_id: @page, id: @cms_attachment
    end
  end

  test "should move attachment down" do
    @page = cms_pages(:home)
    @request.env['HTTP_REFERER'] = cms_page_path(@page)

    assert_difference("Cms::PageAttachment.where(attachment_id: #{@cms_attachment.id}).first.position", 1) do
      patch :down, page_id: @page, id: @cms_attachment
    end
  end
end
