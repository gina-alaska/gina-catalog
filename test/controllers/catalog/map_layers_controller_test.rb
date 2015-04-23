require 'test_helper'

class Catalog::MapLayersControllerTest < ActionController::TestCase
  setup do
    login_user(:portal_admin)
    @map_layer = map_layers(:one)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('MapLayer.count') do
      post :create, map_layer: { name: 'Testing', map_url: 'http://test.com' }, commit: 'Save'

      assert_redirected_to catalog_map_layers_path
    end
  end

  def test_edit
    get :edit, id: @map_layer.id
    assert_response :success
  end

  def test_update
    patch :update, id: @map_layer.id, map_layer: { name: 'Testing2' }, commit: 'Save'

    assert assigns(:map_layer).errors.empty?, assigns(:map_layer).errors.full_messages

    assert_redirected_to catalog_map_layers_path
  end

  def test_destroy
    assert_difference('MapLayer.count', -1) do
      delete :destroy, id: @map_layer.id
    end

    assert_redirected_to catalog_map_layers_path
  end
end
