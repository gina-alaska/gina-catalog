require "test_helper"

class Api::UserControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end

end
