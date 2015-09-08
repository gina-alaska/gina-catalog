require "test_helper"

class Cms::SnippetsControllerTest < ActionController::TestCase
  setup do
    login_user(:admin)
  end
  
  def cms_snippet
    @cms_snippet ||= cms_snippets :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cms_snippets)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Cms::Snippet.count') do
      post :create, cms_snippet: { content: cms_snippet.content, name: cms_snippet.name, portal_id: cms_snippet.portal_id, slug: cms_snippet.slug }
    end

    assert_redirected_to cms_snippet_path(assigns(:cms_snippet))
  end

  def test_show
    get :show, id: cms_snippet
    assert_response :success
  end

  def test_edit
    get :edit, id: cms_snippet
    assert_response :success
  end

  def test_update
    put :update, id: cms_snippet, cms_snippet: { content: cms_snippet.content, name: cms_snippet.name, portal_id: cms_snippet.portal_id, slug: cms_snippet.slug }
    assert_redirected_to cms_snippet_path(assigns(:cms_snippet))
  end

  def test_destroy
    assert_difference('Cms::Snippet.count', -1) do
      delete :destroy, id: cms_snippet
    end

    assert_redirected_to cms_snippets_path
  end
end
