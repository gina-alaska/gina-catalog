require 'test_helper'

class Catalog::TagsControllerTest < ActionController::TestCase
  setup do
    login_user(:portal_admin)
    Entry.public_activity_off
    @entry = entries(:one)
    @tag = @entry.tag_list.add('test')
    @entry.save
  end

  teardown do
    Entry.public_activity_on
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_show
    get :show, id: @tag
    assert_response :success
  end

  def test_remove
    patch :remove, catalog_id: @entry.id, id: 'test'

    assert_redirected_to catalog_tags_path
  end
end
