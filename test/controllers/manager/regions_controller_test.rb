require "test_helper"

class Manager::RegionsControllerTest < ActionController::TestCase
  def test_search
    get :search
    assert_response :success
  end

end
