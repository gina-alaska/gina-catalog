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

  test 'should redirect to test' do
    get :show, slug: 'redirect'
    assert_redirected_to '/test'
  end

  test 'should redirect home to test' do
    @page = cms_pages(:home)
    @page.redirect_url = '/test'
    @page.save

    get :show, slug: 'home'
    assert_redirected_to '/test'
  end
end
