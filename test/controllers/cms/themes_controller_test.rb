require "test_helper"

class Cms::ThemesControllerTest < ActionController::TestCase

  def cms_theme
    @cms_theme ||= cms_themes :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cms_themes)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Cms::Theme.count') do
      post :create, cms_theme: { css: cms_theme.css, name: cms_theme.name, portal_id: cms_theme.portal_id }
    end

    assert_redirected_to cms_theme_path(assigns(:cms_theme))
  end

  def test_show
    get :show, id: cms_theme
    assert_response :success
  end

  def test_edit
    get :edit, id: cms_theme
    assert_response :success
  end

  def test_update
    put :update, id: cms_theme, cms_theme: { css: cms_theme.css, name: cms_theme.name, portal_id: cms_theme.portal_id }
    assert_redirected_to cms_theme_path(assigns(:cms_theme))
  end

  def test_destroy
    assert_difference('Cms::Theme.count', -1) do
      delete :destroy, id: cms_theme
    end

    assert_redirected_to cms_themes_path
  end
end
