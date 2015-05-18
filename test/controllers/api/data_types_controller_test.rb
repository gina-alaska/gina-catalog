require 'test_helper'

class Api::DataTypesControllerTest < ActionController::TestCase
  test 'Should get index' do
    get :index, format: :json
    assert_response :success
    assert_not_empty assigns(:data_types)
  end
end
