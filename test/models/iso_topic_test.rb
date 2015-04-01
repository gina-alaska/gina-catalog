require "test_helper"

class IsoTopicTest < ActiveSupport::TestCase

  def iso_topic
    @iso_topic ||= IsoTopic.new
  end

  def test_valid
    assert iso_topic.valid?
  end

end
