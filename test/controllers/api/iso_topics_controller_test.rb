require 'test_helper'

class Api::IsoTopicsControllerTest < ActionController::TestCase
  test 'Should get index' do
    IsoTopic.reindex
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:iso_topics)
  end
end
