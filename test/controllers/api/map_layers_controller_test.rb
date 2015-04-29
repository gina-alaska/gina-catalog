require 'test_helper'

class Api::MapLayersControllerTest < ActionController::TestCase
  def test_index
    get :index, format: 'json'
    assert_response :success
  end
end
