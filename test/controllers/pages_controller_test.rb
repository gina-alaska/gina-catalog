require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test 'should render index' do
    get :index

    assert_response :success
  end

  test 'should render show' do
    get :show, slug: 'test'

    assert_response :success
  end

  test 'should redirect to page not found' do
    get :show, slug: 'not_found'

    assert_redirected_to page_not_found_path
  end

  test 'should redirect to root_url' do
    get :show, slug: 'home'
    assert_redirected_to root_url
  end
end
