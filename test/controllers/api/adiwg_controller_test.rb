require "test_helper"

class Api::AdiwgControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
  end

  def test_show
    get :show, id:  @entry.id, format: 'json'
    assert_response :success
  end
end
