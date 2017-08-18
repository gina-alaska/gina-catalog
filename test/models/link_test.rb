require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  should belong_to(:entry)
  should validate_length_of(:display_text).is_at_most(255)
  should validate_length_of(:url).is_at_least(11).is_at_most(255).with_message('is not a valid url')
  should validate_inclusion_of(:category).in_array(Link::CATEGORIES).with_message('is not a valid category')
  should validate_uniqueness_of(:uuid)

  test 'test if url is a pdf' do
    link = links(:good_pdf)

    assert link.pdf?, 'link url is not a pdf and should be'
  end

  test 'test if url is not a pdf' do
    link = links(:bad_pdf)

    assert !link.pdf?, 'link url is a pdf and should not be'
  end
end
