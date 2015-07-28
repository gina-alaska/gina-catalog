require 'test_helper'

class DownloadsControllerTest < ActionController::TestCase
  test 'should create new download log for public attachment download' do
    Attachment.any_instance.stubs(:file).returns(OpenStruct.new(path: 'foo', name: 'bar'))
    @controller.stubs(:send_file).returns(true)
    @controller.stubs(:render).returns(true)

    assert_difference('DownloadLog.count') do
      get :show, id: attachments(:public_download).global_id
    end
  end

  test 'should create new download log for private attachment download' do
    Attachment.any_instance.stubs(:file).returns(OpenStruct.new(path: 'foo', name: 'bar'))
    @controller.stubs(:send_file).returns(true)
    @controller.stubs(:render).returns(true)

    assert_difference('DownloadLog.count') do
      get :show, id: attachments(:private_download).global_id
    end
  end

  test 'should handle sds request with redirect' do
    Attachment.any_instance.stubs(:global_id).returns('global_id')
    @attachment = attachments(:public_download)
    get :sds, id: @attachment

    assert_redirected_to download_path('global_id')
  end
end
