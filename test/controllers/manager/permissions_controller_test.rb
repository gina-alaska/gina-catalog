require 'test_helper'

class Manager::PermissionsControllerTest < ActionController::TestCase
  def setup
    @permission = permissions(:one)
    @user = users(:admin)
    session[:user_id] = @user.id
  end

  test "should get index" do
    get :index
    
    assert_response :success
    assert_not_nil assigns(:permissions)
  end  
  
  test "should show site" do
    get :show, id: @permission.id
    
    assert_response :success
    assert_not_nil assigns(:permission)
  end
  
  test "should show new site form" do
    get :new
    
    assert_response :success
    assert_not_nil assigns(:permission)
  end
  
  test "should create site" do
    assert_difference('Site.count') do
      post :create, site: @permission.attributes
      assert assigns(:permission).errors.empty?, assigns(:permission).errors.full_messages
    end

    assert_redirected_to manager_site_path(assigns(:permission))
  end
  
  test "should show edit site form" do
    get :edit, id: @permission.id
    
    assert_response :success
    assert_not_nil assigns(:permission)
  end
  
  test "should update site" do
    patch :update, id: @permission.id, site: { title: 'Testing2' }
    assert_redirected_to manager_site_path(assigns(:permission))
  end
  
  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, id: @permission.id
    end

    assert_redirected_to manager_sites_path
  end
end
