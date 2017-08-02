require "test_helper"

class Cms::PageAttachmentTest < ActiveSupport::TestCase
  def page_attachment
    @page_attachment ||= Cms::PageAttachment.new
  end

  def test_valid
    assert page_attachment.valid?
  end
end
