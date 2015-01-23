require 'test_helper'

class Admin::EntryTypesControllerTest < ActionController::TestCase
  def setup
    @entry_type = entry_types(:one)
    @entry_type_no_assoc = entry_types(:no_associated_entry)
    login_user(:admin)
  end

  test "should get index" do
    get :index
    
    assert_response :success
  end  
  
#  test "should show entry_type" do
#    get :show, id: @entry_type.id
    
#    assert_response :success
#  end 
  
  test "should show new entry_type form" do
    get :new
    
    assert_response :success
  end
  
  test "should create entry_type" do
    assert_difference('EntryType.count') do
      post :create, entry_type: @entry_type.attributes
      assert assigns(:entry_type).errors.empty?, assigns(:entry_type).errors.full_messages
    end

    assert_redirected_to admin_entry_types_path
  end
  
  test "should show edit entry_type form" do
    get :edit, id: @entry_type.id
    
    assert_response :success
  end
  
  test "should update entry_type" do
    patch :update, id: @entry_type.id, entry_type: { name: 'Testing2' }
    assert_redirected_to admin_entry_types_path
  end
  
  test "should destroy entry_type" do
    assert_difference('EntryType.count', -1) do
      delete :destroy, id: @entry_type_no_assoc.id
    end

    assert_redirected_to admin_entry_types_path
  end
end
