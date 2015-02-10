require 'test_helper'

class Api::OrganizationsControllerTest < ActionController::TestCase
  test 'should get index' do
    Organization.reindex
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:organizations)
  end
end
