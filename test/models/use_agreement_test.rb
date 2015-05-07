require 'test_helper'

class UseAgreementTest < ActiveSupport::TestCase
  should ensure_length_of(:title).is_at_most(255)

  should validate_presence_of(:title)
  should validate_presence_of(:body)

  should belong_to(:portal)
  should have_many(:entries)

  test 'check for deletable' do
    use_agreement = use_agreements(:one)
    assert use_agreement.deletable?, 'Use agreement is marked as undeletable when it should be'
  end

  test 'check for undeletable' do
    use_agreement = use_agreements(:one)
    use_agreement.entries << entries(:one)

    assert !use_agreement.deletable?, 'Use agreement is marked as deletable when it should not be'
  end

  test 'should archive use agreement' do
    use_agreement = use_agreements(:one)
    user = users(:one)

    assert_difference('ArchiveItem.count') do
      use_agreement.archive!('Testing archiving', user)
    end
  end

  test 'should unarchive use agreement' do
    use_agreement = use_agreements(:archived)

    assert_difference('ArchiveItem.count', -1) do
      use_agreement.unarchive!
    end
  end
end
