require "test_helper"

class Cms::PagesControllerTest < ActionController::TestCase
  setup do
    login_user(:admin)
  end

  def cms_page
    @cms_page ||= cms_pages :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cms_pages)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Cms::Page.count') do
      post :create, cms_page: { content: cms_page.content, cms_layout_id: cms_page.cms_layout_id, slug: cms_page.slug + '-foo', title: cms_page.title }
    end

    assert_redirected_to cms_page_path(assigns(:cms_page))
  end

  def test_show
    get :show, id: cms_page
    assert_response :success
  end

  def test_edit
    get :edit, id: cms_page
    assert_response :success
  end

  def test_update
    put :update, id: cms_page, cms_page: { content: cms_page.content, cms_layout_id: cms_page.cms_layout_id, slug: cms_page.slug, title: cms_page.title }
    assert_redirected_to cms_page_path(assigns(:cms_page))
  end

  def test_destroy
    assert_difference('Cms::Page.count', -1) do
      delete :destroy, id: cms_page
    end

    assert_redirected_to cms_pages_path
  end
end
