require "test_helper"

class HelpControllerTest < ActionController::TestCase
  #def test_sanity
  #  flunk "Need real tests"
  #end

  test 'should get index' do
    get :index
    assert_response :success
  end
end
