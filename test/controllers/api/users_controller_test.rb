require "test_helper"

class Api::UsersControllerTest < ActionController::TestCase
  test 'should get index' do
    User.reindex
    get :index, format: :json
    assert_response :success
  end
end
