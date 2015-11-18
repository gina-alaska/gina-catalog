require "test_helper"

class SitemapsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end

  def test_xml_index
    get :index, format: 'xml'
    assert_response :success
  end
end
