require 'test_helper'

class Manager::PortalsControllerTest < ActionController::TestCase
  setup do
    @portal = portals(:one)
    login_user(:portal_admin)
  end

  test "should get show" do
    get :show, id: @portal.id

    assert_response :success
    assert_not_nil assigns(:portal)
  end

  test "should get edit" do
    get :edit, id: @portal.id

    assert_response :success
    assert_not_nil assigns(:portal)
  end

  test "should not be allowed to edit a portal they don't have permissions to" do
    get :edit, id: portals(:two).id

    render_template "app/views/welcome/permission_denied"
  end

  test "should get update" do
    patch :update, id: @portal.id, portal: { title: 'Testing2' }
    assert assigns(:portal).errors.empty?, assigns(:portal).errors.full_messages
    assert_redirected_to manager_portal_path
  end

end
