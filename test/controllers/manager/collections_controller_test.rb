require 'test_helper'

class Manager::CollectionsControllerTest < ActionController::TestCase
  setup do
    @collection = collections(:one)
    login_user(:portal_admin)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end
  
  # test "should get show" do
  #  get :show
  #  assert_response :success
  # end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @collection.id
    assert_response :success
  end

  test 'should get create' do
    assert_difference('Collection.count') do
      post :create, collection: @collection.attributes
      assert assigns(:collection).errors.empty?, assigns(:collection).errors.full_messages
    end

    assert_redirected_to manager_collections_path
  end

  test 'should get update' do
    patch :update, id: @collection.id, collection: { name: 'Testing2' }
    assert assigns(:collection).errors.empty?, assigns(:collection).errors.full_messages
    assert_redirected_to manager_collections_path
  end

  test 'should get destroy' do
    assert_difference('Collection.count', -1) do
      delete :destroy, id: @collection.id
    end

    assert_redirected_to manager_collections_path
  end
  
end
