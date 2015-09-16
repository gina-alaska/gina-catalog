require "test_helper"

class PagesControllerTest < ActionController::TestCase
  test 'should render index' do
    get :index

    assert_response :success
  end

    test 'should render show' do
      get :show, id: 'home'

      assert_response :success
    end
end
