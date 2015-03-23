require 'test_helper'

class Catalog::EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
    login_user(:portal_admin)
  end

  #  test "should get show" do
  #    get :show
  #    assert_response :success
  #  end

  test 'should get new' do
    get :new
    assert_nil flash[:error]
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @entry.id
    assert_response :success
  end

  test 'should get create with save' do
    assert_difference('Entry.count') do
      post :create, entry: @entry.attributes, commit: 'Save'
      assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    end

    assert_redirected_to edit_catalog_entry_path(assigns(:entry))
  end

  test 'should get create with ajax save' do
    assert_difference('Entry.count') do
      xhr :post, :create, entry: @entry.attributes, commit: 'Save'
      assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    end

    assert_response :success
  end

  test 'should get create with save and close' do
    assert_difference('Entry.count') do
      post :create, entry: @entry.attributes, commit: 'Save & Close'
      assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    end

    assert_redirected_to entries_path
  end

  test 'should get create with ajax save and close' do
    assert_difference('Entry.count') do
      xhr :post, :create, entry: @entry.attributes, commit: 'Save & Close'
      assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    end

    assert_response :success
  end

  test 'should update entry record with save' do
    patch :update, id: @entry.id, entry: { name: 'Testing2' }, commit: 'Save'

    assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    assert_redirected_to edit_catalog_entry_path(assigns(:entry))
  end

  test 'should update entry record with ajax save' do
    xhr :patch, :update, id: @entry.id, entry: { name: 'Testing2' }, commit: 'Save'

    assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    assert_response :success
  end

  test 'should update entry record with save and close' do
    patch :update, id: @entry.id, entry: { name: 'Testing2' }, commit: 'Save & Close'

    assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    assert_redirected_to entries_path
  end

  test 'should update entry record with ajax save and close' do
    xhr :patch, :update, id: @entry.id, entry: { name: 'Testing2' }, commit: 'Save & Close'

    assert assigns(:entry).errors.empty?, assigns(:entry).errors.full_messages
    assert_response :success
  end

  test 'should get destroy' do
    assert_difference('Entry.count', -1) do
      delete :destroy, id: @entry.id
    end

    assert_redirected_to entries_path
  end

  test 'update should fail if updating editing from portal other than owner portal' do
    request.host = portals(:two).default_url.url
    patch :update, id: @entry.id, entry: { name: 'Testing2' }
    render_template 'app/views/welcome/permission_denied'
  end
end
