require "test_helper"

class Manager::TagsControllerTest < ActionController::TestCase
  def test_search
    get :search
    assert_response :success
  end

end
