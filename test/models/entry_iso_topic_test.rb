require 'test_helper'

class EntryIsoTopicTest < ActiveSupport::TestCase
  def entry_iso_topic
    @entry_iso_topic ||= EntryIsoTopic.new
  end

  def test_valid
    assert entry_iso_topic.valid?
  end
end
