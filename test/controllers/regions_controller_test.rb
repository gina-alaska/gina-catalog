require "test_helper"

class RegionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end

end
