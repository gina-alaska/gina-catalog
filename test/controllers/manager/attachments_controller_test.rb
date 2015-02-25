require "test_helper"

class Manager::AttachmentsControllerTest < ActionController::TestCase
  def test_show
    get :show
    assert_response :success
  end

  def test_map
    get :map
    assert_response :success
  end

end
