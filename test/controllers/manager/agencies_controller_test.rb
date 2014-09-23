require 'test_helper'

class Manager::AgenciesControllerTest < ActionController::TestCase
  def setup
    @agency = agencies(:one)
    @user = users(:admin)
    session[:user_id] = @user.id
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @agency.id
    
    assert_response :success
    assert_not_nil assigns(:agency)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @agency.id
    
    assert_response :success
    assert_not_nil assigns(:agency)
  end

  test "should post create" do
    assert_difference('Agency.count') do
      post :create, agency: @agency.attributes
      assert assigns(:agency).errors.empty?, assigns(:agency).errors.full_messages
    end

    assert_redirected_to manager_agency_path(assigns(:agency))
  end

  test "should patch update" do
    patch :update, id: @agency.id, agency: { name: 'Testing2' }
    assert assigns(:agency).errors.empty?, assigns(:agency).errors.full_messages
    assert_redirected_to manager_agencies_path
  end

  test "should destroy" do
    assert_difference('Agency.count', -1) do
      delete :destroy, id: @agency.id
    end

    assert_redirected_to manager_agencies_path
  end
end
