require "test_helper"

class Cms::AttachmentTest < ActiveSupport::TestCase

  def attachment
    @attachment ||= Cms::Attachment.new
  end

  def test_valid
    assert attachment.valid?
  end

end
