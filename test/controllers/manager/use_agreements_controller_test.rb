require 'test_helper'

class Manager::UseAgreementsControllerTest < ActionController::TestCase
  def setup
    @use_agreement = use_agreements(:one)
    login_user(:portal_admin)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

#  test "should get show" do
#    get :show
#    assert_response :success
#  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @use_agreement.id
    
    assert_response :success
    assert_not_nil assigns(:use_agreement)
  end

  test "should get create" do
    assert_difference('UseAgreement.count') do
      post :create, use_agreement: @use_agreement.attributes
      assert assigns(:use_agreement).errors.empty?, assigns(:use_agreement).errors.full_messages
    end

    assert_redirected_to manager_use_agreements_path
  end

  test "should get update" do
    patch :update, id: @use_agreement.id, use_agreement: { name: 'Testing2' }
    assert assigns(:use_agreement).errors.empty?, assigns(:use_agreement).errors.full_messages
    assert_redirected_to manager_use_agreements_path
  end

  test "should get destroy" do
    assert_difference('UseAgreement.count', -1) do
      delete :destroy, id: @use_agreement.id
    end

    assert_redirected_to manager_use_agreements_path
  end

end
