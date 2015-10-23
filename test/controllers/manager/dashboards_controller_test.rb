require 'test_helper'

class Manager::DashboardsControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
    login_user(:portal_admin)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @entry

    assert_response :success
    assert_not_nil assigns(:entry)
  end

  test 'should get downloads' do
    get :downloads
    assert_response :success
  end

  test 'should get links' do
    get :links
    assert_response :success
  end
end
