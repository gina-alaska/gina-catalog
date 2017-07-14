require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @useradmin = users(:admin)
    login_user(:admin)
  end

  test 'should get index' do
    get :index

    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'should show edit user form for global admin' do
    get :edit, id: @useradmin.id

    assert_response :success
  end

  test 'should update user' do
    patch :update, id: @useradmin.id, user: { global_admin: '0' }

    assert_redirected_to admin_users_path
  end

  test 'should not show edit user form for basic user' do
    @userone = users(:one)
    login_user(:one)
    get :edit, id: @userone.id

    assert_response :redirect
  end

  test 'should only allow global_admin field to be edited' do
    patch :update, id: @useradmin.id, user: { name: 'Test Two', email: 'user@junk.com', global_admin: '0' }

    assert_equal %w[global_admin updated_at], assigns(:user).previous_changes.keys
  end
end
