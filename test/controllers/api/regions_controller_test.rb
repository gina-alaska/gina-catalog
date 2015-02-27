require 'test_helper'

class Api::RegionsControllerTest < ActionController::TestCase
  test 'Should get index' do
    get :index, format: :json
    assert_response :success
  end
end
