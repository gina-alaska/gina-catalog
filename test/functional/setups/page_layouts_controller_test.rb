require 'test_helper'

class Setups::PageLayoutsControllerTest < ActionController::TestCase
  setup do
    @setups_page_layout = setups_page_layouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:setups_page_layouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create setups_page_layout" do
    assert_difference('Setups::PageLayout.count') do
      post :create, setups_page_layout: { content: @setups_page_layout.content, name: @setups_page_layout.name }
    end

    assert_redirected_to setups_page_layout_path(assigns(:setups_page_layout))
  end

  test "should show setups_page_layout" do
    get :show, id: @setups_page_layout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @setups_page_layout
    assert_response :success
  end

  test "should update setups_page_layout" do
    put :update, id: @setups_page_layout, setups_page_layout: { content: @setups_page_layout.content, name: @setups_page_layout.name }
    assert_redirected_to setups_page_layout_path(assigns(:setups_page_layout))
  end

  test "should destroy setups_page_layout" do
    assert_difference('Setups::PageLayout.count', -1) do
      delete :destroy, id: @setups_page_layout
    end

    assert_redirected_to setups_page_layouts_path
  end
end
