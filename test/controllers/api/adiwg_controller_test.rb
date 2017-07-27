require "test_helper"

class Api::AdiwgControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end

end
