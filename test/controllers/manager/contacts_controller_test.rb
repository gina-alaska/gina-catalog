require 'test_helper'

class Manager::ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
    @contact_no_assoc = contacts(:no_associated_entry)
    login_user(:portal_admin)
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
    assert_difference('Contact.count') do
      post :create, contact: @contact.attributes
      assert assigns(:contact).errors.empty?, assigns(:contact).errors.full_messages
    end

    assert_redirected_to manager_contacts_path
  end

  test "should get update" do
    patch :update, id: @contact.id, contact: { name: 'Testing2' }
    assert assigns(:contact).errors.empty?, assigns(:contact).errors.full_messages
    assert_redirected_to manager_contacts_path
  end

  test "should get destroy" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact_no_assoc.id
    end

    assert_redirected_to manager_contacts_path
  end

end
