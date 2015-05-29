require 'test_helper'

class Api::UseAgreementsControllerTest < ActionController::TestCase
  def test_index
    get :index, format: 'json'
    assert_response :success
  end
end
