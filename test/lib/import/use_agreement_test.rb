require 'test_helper'
require 'import'

class Import::UseAgreementTest < ActiveSupport::TestCase
  test 'should create valid use agreement' do
    use_agreement_import = Import::UseAgreement.new(portals(:one))
    import = use_agreement_import.create(
      'id' => 2,
      'title' => 'Generic Use Agreement',
      'body' => 'Use agreement test.',
      'required' => 'true'
    )
    assert import.importable.valid?, import.importable.errors.full_messages
  end
end