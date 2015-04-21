require 'test_helper'

class Manager::MapLayersControllerTest < ActionController::TestCase
  setup do
    login_user(:portal_admin)
    @entry = entries(:one)
    @map_layer = map_layers(:one)
  end

  def test_new
    xhr :get, :new, entry_id: @entry.id, format: 'js'
    assert_response :success
  end

  def test_create
    assert_difference('MapLayer.count') do
      xhr :post, :create, entry_id: @entry.id, entry: @entry.attributes, map_layer: { name: 'Testing', url: 'http://test.com' }
      assert_response :success
    end
  end

  def test_edit
    xhr :get, :edit, id: @map_layer.id, entry_id: @map_layer.entry_id
    assert_response :success
  end

  def test_update
    patch :update, entry_id: @map_layer.entry_id, id: @map_layer.id, map_layer: { name: 'Testing2' }, commit: 'Save'

    assert assigns(:map_layer).errors.empty?, assigns(:map_layer).errors.full_messages

    assert_redirected_to edit_manager_entry_path(@entry)
  end

  def test_destroy
    xhr :get, :destroy, entry_id: @map_layer.entry_id, id: @map_layer.id
    assert_response :success
  end
end
