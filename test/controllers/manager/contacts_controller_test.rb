require 'test_helper'

class Manager::ContactsControllerTest < ActionController::TestCase
  def setup
    @contact = contacts(:one)
    @user = users(:admin)
    session[:user_id] = @user.id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  #test "should get show" do
  #  get :show
  #  assert_response :success
  #end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact.id
    assert_response :success
  end

  test "should get create" do
    post :create, contact: @contact.attributes
    assert assigns(:contact).errors.empty?, assigns(:contact).errors.full_messages
    assert_redirected_to manager_contacts_path
  end

  test "should get update" do
    put :update, id: @contact.id, contact: @contact.attributes
    assert assigns(:contact).errors.empty?, assigns(:contact).errors.full_messages
    assert_redirected_to manager_contacts_path
  end

  test "should get destroy" do
    delete :destroy, id: @contact.id
    assert_redirected_to manager_contacts_path
  end

end
