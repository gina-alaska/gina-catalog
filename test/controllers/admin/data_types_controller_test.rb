require 'test_helper'

class Admin::DataTypesControllerTest < ActionController::TestCase
  setup do
    @data_type = data_types(:one)
    login_user(:admin)
  end

  test 'should get index' do
    get :index

    assert_response :success
  end

  #  test "should show data_type" do
  #    get :show, id: @data_type.id

  #    assert_response :success
  #  end

  test 'should show new data_type form' do
    get :new

    assert_response :success
  end

  test 'should create data_type' do
    assert_difference('DataType.count') do
      post :create, data_type: @data_type.attributes
      assert assigns(:data_type).errors.empty?, assigns(:data_type).errors.full_messages
    end

    assert_redirected_to admin_data_types_path
  end

  test 'should show edit data_type form' do
    get :edit, id: @data_type.id

    assert_response :success
  end

  test 'should update data_type' do
    patch :update, id: @data_type.id, data_type: { name: 'Testing2' }
    assert_redirected_to admin_data_types_path
  end

  test 'should destroy data_type' do
    assert_difference('DataType.count', -1) do
      delete :destroy, id: @data_type.id
      assert assigns(:data_type).errors.empty?, assigns(:data_type).errors.full_messages
    end

    assert_redirected_to admin_data_types_path
  end
end
