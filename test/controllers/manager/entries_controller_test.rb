require 'test_helper'

class Manager::EntriesControllerTest < ActionController::TestCase
  def setup
    @entry = entries(:one)

    login_user(:portal_admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @entry.id
    assert_response :success
  end

  test "should get create" do
    assert_difference('Entry.count') do
      post :create, entry: @entry.attributes
      assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    end

    assert_redirected_to manager_entries_path
  end

  test "should update entry record" do
    patch :update, id: @entry.id, entry: { name: 'Testing2' }
    assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    assert_redirected_to manager_entries_path
  end

  test "should get destroy" do
    assert_difference('Entry.count', -1) do
      delete :destroy, id: @entry.id
    end

    assert_redirected_to manager_entries_path
  end

  test "update should fail if updating editing from site other than owner site" do
    request.host = sites(:two).default_url.url
    patch :update, id: @entry.id, entry: { name: 'Testing2' }
    assert_equal flash[:alert], "You are not authorized to access this page."   
    assert_redirected_to root_path
  end

end
