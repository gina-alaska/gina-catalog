require 'test_helper'

class Admin::PortalsControllerTest < ActionController::TestCase
  setup do
    @portal = portals(:one)
    # @portal_no_urls = portals(:two)
    login_user(:admin)
  end

  test 'should get index' do
    get :index

    assert_response :success
    assert_not_nil assigns(:portals)
  end

  test 'should show portal' do
    get :show, id: @portal.id

    assert_response :success
    assert_not_nil assigns(:portal)
  end

  # test "should show portal with no urls" do
  #  get :show, id: @portal_no_urls.id
  #
  #  assert_response :success
  #  assert_not_nil assigns(:portal)
  # end

  test 'should show new portal form' do
    get :new

    assert_response :success
    assert_not_nil assigns(:portal)
  end

  test 'should create portal' do
    assert_difference('Portal.count') do
      post :create, portal: { title: 'Test Portal Create', acronym: 'TPC' }
      assert assigns(:portal).errors.empty?, assigns(:portal).errors.full_messages
    end

    assert_redirected_to admin_portal_path(assigns(:portal))
  end

  test 'should show edit portal form' do
    get :edit, id: @portal.id

    assert_response :success
    assert_not_nil assigns(:portal)
  end

  test 'should update portal' do
    patch :update, id: @portal.id, portal: { title: 'Testing2' }
    assert_redirected_to admin_portal_path(assigns(:portal))
  end

  # Currently there is no destroy portal
  #  test "should destroy portal" do
  #    assert_difference('Portal.count', -1) do
  #      delete :destroy, id: @portal.id
  #    end

  #    assert_redirected_to admin_portals_path
  #  end

  test 'non global admin user should not be able to create portal' do
    login_user :portal_admin

    assert_difference('Portal.count', 0) do
      post :create, portal: @portal.attributes
      assert assigns(:portal).errors.empty?, assigns(:portal).errors.full_messages
    end
  end

  test 'non global admin user should not be able to access new portal method' do
    login_user :portal_admin

    get :new

    assert_response :redirect
  end
end
