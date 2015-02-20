require 'test_helper'

class Manager::OrganizationsControllerTest < ActionController::TestCase
  setup do
    @organization = organizations(:one)
    @organization_no_assoc = organizations(:no_associated_entry)
    login_user(:portal_admin)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @organization.id

    assert_response :success
    assert_not_nil assigns(:organization)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @organization.id

    assert_response :success
    assert_not_nil assigns(:organization)
  end
  
  test 'should get create' do
    assert_difference('Organization.count') do
      post :create, organization: @organization.attributes
      assert assigns(:organization).errors.empty?, assigns(:organization).errors.full_messages
    end

    assert_redirected_to manager_organizations_path
  end

  test 'should patch update' do
    patch :update, id: @organization.id, organization: { name: 'Testing2' }
    assert assigns(:organization).errors.empty?, assigns(:organization).errors.full_messages
    assert_redirected_to manager_organizations_path
  end

  test 'should destroy' do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization_no_assoc.id
    end

    assert_redirected_to manager_organizations_path
  end
end
