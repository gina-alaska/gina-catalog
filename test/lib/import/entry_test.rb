require 'test_helper'
require 'import'

class Import::EntryTest < ActiveSupport::TestCase
  def setup
    icontact = import_items(:two)
    icontact.importable = contacts(:one)
    icontact.save
  end

  test 'should return an entry type instance' do
    assert_kind_of EntryType, Import::Entry.new(portals(:one)).entry_type('data')
  end

  test 'should create valid catalog entry' do
    entry_import = Import::Entry.new(portals(:one))
    import = entry_import.create('id' => 123, 'title' => 'test',
                                 'description' => 'test', 'status' => 'Unknown',
                                 'type' => 'project',
                                 'primary_agency' => {
                                   'name' => 'Geographic Information Network of Alaska'
                                 },
                                 'funding_agency' => {
                                   'name' => 'Geographic Information Network of Alaska'
                                 },
                                 'primary_contact' => {
                                   'id' => 2
                                 },
                                 'contacts' => [{
                                   'id' => 2
                                 }],
                                 'collections' => [{
                                   'id' => 3
                                 }],
                                 'use_agreement' => {
                                   'id' => 4
                                 },
                                 'regions' => [{
                                   'id' => 5
                                 }],
                                 'data_types' => [
                                   { 'name' => 'GIS' }
                                 ],
                                 'iso_topics' => [
                                   { 'iso_theme_code' => '001' },
                                   { 'iso_theme_code' => '002' }
                                 ],
                                 'uploads' => [
                                   { 'name' => 'test.com', 'url' => 'http://test.com', 'downloadable' => true },
                                   { 'name' => 'foo.com', 'url' => 'http://foo.com', 'preview' => true }

                                 ],
                                 'links' => [{
                                   'display_text' => 'website',
                                   'url' => 'http://test.com',
                                   'category' => 'Website'
                                 }]
                                )
    assert import.importable.valid?, import.importable.errors.full_messages
    assert_not_empty import.importable.primary_organizations
    assert_not_empty import.importable.funding_organizations
    assert_not_empty import.importable.primary_contacts
    assert_not_empty import.importable.contacts
    assert_not_empty import.importable.links
    assert_not_empty import.importable.collections
    assert_not_empty import.importable.iso_topics
    assert_not_empty import.importable.regions
    assert_not_empty import.importable.data_types
    assert_not_empty import.importable.attachments
    assert_not_nil import.importable.use_agreement
  end

  test 'should add contacts to model' do
    model = OpenStruct.new(contacts: [], primary_contacts: [])
    import = Import::Entry.new(portals(:one))
    import.add_contacts(model, 'primary_contact' => { 'id' => 2 }, 'contacts' => [{ 'id' => 2 }])

    assert_not_empty model.contacts
    assert_not_empty model.primary_contacts
  end
end
