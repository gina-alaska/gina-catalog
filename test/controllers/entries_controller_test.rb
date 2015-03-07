require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @entry = entries(:one)
    login_user(:portal_admin)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
    assert_not_nil assigns(:facets)
    assert_not_nil assigns(:search_params)
  end

  test 'should get show' do
    get :show, id: @entry

    assert_response :success
    assert_not_nil assigns(:entry)
  end
end
