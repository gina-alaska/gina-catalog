require 'test_helper'

class Admin::IsoTopicsControllerTest < ActionController::TestCase
  setup do
    @iso_topic = iso_topics(:one)
    @iso_topic_no_assoc = iso_topics(:no_associated_entry)
    login_user(:admin)
  end

  test 'should get index' do
    get :index

    assert_response :success
  end

  test 'should show new iso_topic form' do
    get :new

    assert_response :success
  end

  test 'should create iso_topic' do
    assert_difference('IsoTopic.count') do
      post :create, iso_topic: @iso_topic.attributes
      assert assigns(:iso_topic).errors.empty?, assigns(:iso_topic).errors.full_messages
    end

    assert_redirected_to admin_iso_topics_path
  end

  test 'should show edit iso_topic form' do
    get :edit, id: @iso_topic.id

    assert_response :success
  end

  test 'should update iso_topic' do
    patch :update, id: @iso_topic.id, iso_topic: { name: 'Testing2' }
    assert_redirected_to admin_iso_topics_path
  end

  test 'should destroy iso_topic' do
    assert_difference('IsoTopic.count', -1) do
      delete :destroy, id: @iso_topic_no_assoc.id
    end

    assert_redirected_to admin_iso_topics_path
  end
end
