require 'test_helper'

class Manager::PermissionsControllerTest < ActionController::TestCase
  setup do
    request.host = portals(:one).urls.first.url

    @permission = permissions(:one)
    @user = users(:one)

    login_user(:portal_admin)
  end

  test "should get index" do
    get :index

    assert_response :success
    assert_not_nil assigns(:permissions)
  end

  test "show should redirect to edit" do
    get :show, id: @permission.id

    assert_redirected_to edit_manager_permission_path(assigns(:permission))
  end

  test "should show new permission form" do
    get :new, user_id: @user.id

    assert_response :success
    assert_not_nil assigns(:permission)
  end

  test "should create permission" do
    assert_difference('Permission.count') do
      post :create, permission: @permission.attributes
      assert assigns(:permission).errors.empty?, assigns(:permission).errors.full_messages
    end

    assert_redirected_to manager_permissions_path
  end

  test "should show edit permission form" do
    get :edit, id: @permission.id

    assert_response :success
    assert_not_nil assigns(:permission)
  end

  test "should update permission" do
    patch :update, id: @permission.id, permission: { cms_manager: 0 }
    assert_redirected_to manager_permissions_path
  end

  test "should destroy permission" do
    assert_difference('Permission.count', -1) do
      delete :destroy, id: @permission.id
    end

    assert_redirected_to manager_permissions_path
  end
end
