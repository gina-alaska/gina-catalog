require 'test_helper'

class Catalog::EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
    login_user(:portal_admin)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
    assert_not_nil assigns(:facets)
    assert_not_nil assigns(:search_params)
  end

  test 'should render entry without owner portal' do
    get :show, id: entries(:no_owner)
    assert_response :success
  end

  test 'should only try to query non-archived records by default' do
    get :index
    assert_response :success
    assert assigns(:search_params).keys.include?(:archived), 'Archived search param was not found'
    assert_equal false, assigns(:search_params)[:archived]
  end

  test 'should get show' do
    get :show, id: @entry

    assert_response :success
    assert_not_nil assigns(:entry)
  end

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

    assert_redirected_to catalog_entry_path(assigns(:entry))
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
    assert_redirected_to catalog_entry_path(assigns(:entry))
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

    assert_redirected_to catalog_entries_path
  end

  test 'update should fail if updating editing from portal other than owner portal' do
    request.host = portals(:two).default_url.url
    patch :update, id: @entry.id, entry: { name: 'Testing2' }
    render_template 'app/views/welcome/permission_denied'
  end

  test 'should archive entry' do
    assert_difference('ArchiveItem.count') do
      patch :archive, id: @entry.id, message: 'Testing'
    end

    assert_redirected_to catalog_entry_path(@entry)
  end

  test 'should unarchive entry' do
    patch :archive, id: @entry.id, message: 'Testing'
    assert_difference('ArchiveItem.count', -1) do
      patch :unarchive, id: @entry.id, archive: {}
    end

    assert_redirected_to catalog_entry_path(@entry)
  end

  test 'should publish entry' do
    login_user(:data_manager)
    @entry = entries(:unpublished)
    assert_difference('Entry.published.count') do
      patch :publish, id: @entry.id
    end

    assert_redirected_to catalog_entry_path(@entry)
  end

  test 'should fail to publish entry' do
    login_user(:two)
    @entry = entries(:unpublished)
    assert_difference('Entry.published.count', 0) do
      patch :publish, id: @entry.id
    end

    assert_redirected_to permission_denied_path
  end

  test 'should unpublish entry' do
    login_user(:data_manager)
    @entry = entries(:published)
    assert_difference('Entry.published.count', -1) do
      patch :unpublish, id: @entry.id
    end

    assert_redirected_to catalog_entry_path(@entry)
  end

  test 'should fail to unpublish entry' do
    login_user(:two)
    @entry = entries(:published)
    assert_difference('Entry.published.count', 0) do
      patch :unpublish, id: @entry.id
    end

    assert_redirected_to permission_denied_path
  end
end
