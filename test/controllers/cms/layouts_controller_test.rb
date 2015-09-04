require "test_helper"

class Cms::LayoutsControllerTest < ActionController::TestCase

  def cms_layout
    @cms_layout ||= cms_layouts :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cms_layouts)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Cms::Layout.count') do
      post :create, cms_layout: { content: cms_layout.content, name: cms_layout.name, portal_id: cms_layout.portal_id }
    end

    assert_redirected_to cms_layout_path(assigns(:cms_layout))
  end

  def test_edit
    get :edit, id: cms_layout
    assert_response :success
  end

  def test_update
    put :update, id: cms_layout, cms_layout: { content: cms_layout.content, name: cms_layout.name, portal_id: cms_layout.portal_id }
    assert_redirected_to cms_layout_path(assigns(:cms_layout))
  end

  def test_destroy
    assert_difference('Cms::Layout.count', -1) do
      delete :destroy, id: cms_layout
    end

    assert_redirected_to cms_layouts_path
  end
end
