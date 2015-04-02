require "test_helper"

class IsoTopicTest < ActiveSupport::TestCase

  should validate_length_of(:name).is_at_most(50)
  should validate_length_of(:long_name).is_at_most(200)
  should validate_length_of(:iso_theme_code).is_at_most(3)

end
