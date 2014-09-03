require 'test_helper'

class Admin::SitesControllerTest < ActionController::TestCase
  def setup
    @site = sites(:one)
    @user = users(:admin)
    session[:user_id] = @user.id
  end
  
  test "should get index" do
    get :index
    
    assert_response :success
    assert_not_nil assigns(:sites)
  end  
  
  test "should show site" do
    get :show, id: @site.id
    
    assert_response :success
    assert_not_nil assigns(:site)
  end 
  
  test "should show new site form" do
    get :new
    
    assert_response :success
    assert_not_nil assigns(:site)
  end
  
  test "should create site" do
    assert_difference('Site.count') do
      post :create, site: @site.attributes
      assert assigns(:site).errors.empty?, assigns(:site).errors.full_messages
    end

    assert_redirected_to admin_site_path(assigns(:site))
  end
  
  test "should show edit site form" do
    get :edit, id: @site.id
    
    assert_response :success
    assert_not_nil assigns(:site)
  end
  
  test "should update site" do
    patch :update, id: @site.id, site: { title: 'Testing2' }
    assert_redirected_to admin_site_path(assigns(:site))
  end
  
  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, id: @site.id
    end

    assert_redirected_to admin_sites_path
  end
end
