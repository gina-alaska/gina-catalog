require "test_helper"

class Cms::SnippetTest < ActiveSupport::TestCase

  def snippet
    @snippet ||= Cms::Snippet.new
  end

  def test_valid
    assert snippet.valid?
  end

end
