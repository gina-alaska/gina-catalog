require 'test_helper'

class Manager::InvitationsControllerTest < ActionController::TestCase
  def setup
    request.host = portals(:one).urls.first.url
    
    @invitation = invitations(:two)
    @permission = permissions(:one)
    @user = users(:two)
    
    login_user(:portal_admin)

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
  
  test "should accept invitation" do
    login_user(:two)
    get :accept, id: @invitation

    assert_equal @user.email, @invitation.email
    assert_equal "You have been granted access to #{@permission.portal.title}", flash[:notice]
    assert_redirected_to manager_path
  end
  
  test "should not accept invitation from another user" do
    login_user(:one)
    get :accept, id: @invitation
    
    assert_equal "The email address associated with this account does not match the invitation address.  We are unable to give you access to Test Catalog", flash[:error]
    assert_redirected_to root_path
  end
  
  test "should gracefully handle invitations that no longer exist" do
    login_user(:two)
    get :accept, id: "5e9c1347-d18f-4ec0-bf0f-c5f46d79a000"
    
    
    assert_equal "We're sorry but the requested invitation is no longer available", flash[:error]
    assert_redirected_to root_path
  end
  
  test "should show new invitation form" do
    get :new
    
    assert_response :success
    assert_not_nil assigns(:invitation)
  end
  
  test "should create invitation" do
    assert_difference('Invitation.count') do
      post :create, invitation: @invitation.attributes.merge({ permission_attributes: @permission.roles })
      assert assigns(:invitation).errors.empty?, assigns(:invitation).errors.full_messages
    end

    assert_redirected_to manager_permissions_path
  end
  
  test "should show edit invitation form" do
    get :edit, id: @invitation
    
    assert_response :success
    assert_not_nil assigns(:invitation)
  end
  
  test "should update invitation" do
    patch :update, id: @invitation, invitation: { email: 'test@foo.com' }
    assert_redirected_to manager_permissions_path
  end
  
  test "should destroy invitation" do
    assert_difference('Invitation.count', -1) do
      delete :destroy, id: @invitation
    end

    assert_redirected_to manager_permissions_path
  end
end
