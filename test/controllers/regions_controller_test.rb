require 'test_helper'

class RegionsControllerTest < ActionController::TestCase
  test 'Should get index' do
    get :index, format: :json
    assert_response :success
  end
end
