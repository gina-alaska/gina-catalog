require 'test_helper'

class Api::ContactsControllerTest < ActionController::TestCase
  test 'should get index' do
    Contact.reindex
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:contacts)
  end
end
