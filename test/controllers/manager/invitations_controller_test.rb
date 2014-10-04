require 'test_helper'

class Manager::InvitationsControllerTest < ActionController::TestCase
  def setup
    request.host = sites(:one).urls.first.url
    
    @invitation = invitations(:one)
    @user = users(:one)
    
    @admin = users(:admin)
    session[:user_id] = @admin.id
  end

  # test "should get index" do
  #   get :index
  #
  #   assert_response :success
  #   assert_not_nil assigns(:invitations)
  # end
  
  # test "show should redirect to edit" do
  #   get :show, id: @permission.id
  #
  #   assert_redirected_to edit_manager_permission_path(assigns(:permission))
  # end
  
  test "should show new invitation form" do
    get :new
    
    assert_response :success
    assert_not_nil assigns(:invitation)
  end
  
  test "should create invitation" do
    assert_difference('Invitation.count') do
      post :create, invitation: @invitation.attributes
      assert assigns(:invitation).errors.empty?, assigns(:invitation).errors.full_messages
    end

    assert_redirected_to manager_permissions_path
  end
  
  test "should show edit invitation form" do
    get :edit, id: @invitation.id
    
    assert_response :success
    assert_not_nil assigns(:invitation)
  end
  
  test "should update invitation" do
    patch :update, id: @invitation.id, invitation: { email: 'test@foo.com' }
    assert_redirected_to manager_permissions_path
  end
  
  test "should destroy invitation" do
    assert_difference('Invitation.count', -1) do
      delete :destroy, id: @invitation.id
    end

    assert_redirected_to manager_permissions_path
  end
end
