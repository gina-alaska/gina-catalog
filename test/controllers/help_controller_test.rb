require "test_helper"

class HelpControllerTest < ActionController::TestCase
  #def test_sanity
  #  flunk "Need real tests"
  #end

  test 'should get cms' do
    xhr :get, :cms, format: :js, id: 'pages'

    assert_equal "text/javascript", @response.content_type
    assert_response :success
  end
end
