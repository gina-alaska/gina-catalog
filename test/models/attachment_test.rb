require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  should ensure_length_of(:description).is_at_most(255)

  should belong_to(:entry)

  # should validate_presence_of :file_uid
  # should validate_presence_of :uuid

  test 'bbox should not be created if attachment is thumbnail file' do
    thumbnail = attachments(:thumbnail)

    thumbnail.expects(:build_bbox).never
    thumbnail.save
  end

  test 'bbox should not be created if attachment is a public download file' do
    public_download = attachments(:public_download)

    public_download.expects(:build_bbox).never
    public_download.save
  end

  test 'bbox should not be created if attachment is a private download file' do
    private_download = attachments(:private_download)

    private_download.expects(:build_bbox).never
    private_download.save
  end

  test 'bbox should be created if attachment is a Geojson file' do
    bounds = mock
    bounds.stubs(:from_geojson).returns(bounds)
    bounds.stubs(:save)
    file = mock
    file.stubs(:data)

    geojson = attachments(:geojson)
    geojson.stubs(:file).returns(file)
    geojson.expects(:build_bbox).returns(bounds)
    geojson.save
  end
end
