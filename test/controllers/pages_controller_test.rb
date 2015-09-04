require "test_helper"

class PagesControllerTest < ActionController::TestCase
  test 'should render index' do
    get :index

    assert_response :success
  end
end
