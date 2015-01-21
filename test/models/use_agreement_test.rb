require 'test_helper'

class UseAgreementTest < ActiveSupport::TestCase
  should ensure_length_of(:title).is_at_most(255)

  should validate_presence_of(:title)
  should validate_presence_of(:body)

  should belong_to(:portal)
  should have_many(:entries)

  test "check for deletable" do
    use_agreement = use_agreements(:one)
    assert use_agreement.deletable?, "Use agreement is marked as undeletable when it should be"
  end

  test "check for undeletable" do
    use_agreement = use_agreements(:one)
    use_agreement.entries << entries(:one)

    assert !use_agreement.deletable?, "Use agreement is marked as deletable when it should not be"
  end

  test "check for use_agreement archive" do
    use_agreement = use_agreements(:one)
    use_agreement.archive
    assert use_agreement.archived, "Use agreement has been archived but it did not take"
  end

  test "check for use_agreement unarchive" do
    use_agreement = use_agreements(:archived)
    use_agreement.unarchive
    assert !use_agreement.archived, "Use agreement has been unarchived but it did not take"
  end
end
