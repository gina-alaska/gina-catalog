require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = entries(:one)
    @multiowners = entries(:multi_owner)
  end

  should have_many(:attachments)
  should have_many(:entry_contacts)
  should have_many(:contacts).through(:entry_contacts)
  should have_many(:entry_aliases)
  should have_many(:entry_organizations)
  should have_many(:organizations).through(:entry_organizations)
  should have_many(:entry_portals)
  should have_many(:portals).through(:entry_portals)
  should have_many(:activity_logs)
  should have_many(:entry_regions)
  should have_many(:regions).through(:entry_regions)
  should have_many(:entry_map_layers)
  should have_many(:map_layers).through(:entry_map_layers)

  should validate_presence_of(:title)
  should validate_presence_of(:status)
  should validate_presence_of(:entry_type_id)

  should validate_length_of(:slug).is_at_most(255)
  should validate_length_of(:title).is_at_most(255)
  # should validate_length_of(:portals).is_at_least(1)

  should belong_to(:entry_type)
  should have_one(:owner_entry_portal)
  should have_one(:owner_portal).through(:owner_entry_portal)

  test 'ensure length of portals is at least 1' do
    entry = Entry.create(
      title: 'Testing', description: 'test', status: 'Unknown',
      entry_type: entry_types(:one), portals: [portals(:one), portals(:two)]
    )

    assert_equal 2, entry.portals.count
  end

  test "shouldn't allow more than one owner portal" do
    @entry.entry_portals.each { |es| es.update_attribute(:owner, true) }
    assert !@entry.valid?
    assert_equal ['cannot specify more than one owner'], @entry.errors['portals']
  end

  test "shouldn't save invalid record" do
    entry = Entry.new

    assert_not entry.save
  end

  test 'on create the first portal should become the owner portal' do
    entry = Entry.create(
      title: 'Testing', description: 'test', status: 'Unknown',
      entry_type: entry_types(:one), portals: [portals(:one), portals(:two)]
    )

    assert entry.valid?, "Entry was not valid: #{@entry.errors.full_messages.join(', ')}"
    assert entry.owner_portal.present?, 'Owner portal was empty'
  end

  test 'owner_portal_count should return the correct counts' do
    assert_equal 1, @entry.owner_portal_count
    assert_equal 2, @multiowners.owner_portal_count
  end

  test 'is entry published?' do
    entry = entries(:published)

    assert entry.published?, 'Entry is not published when it should be.'
  end

  test 'is entry unpublished?' do
    entry = entries(:unpublished)

    assert !entry.published?, 'Entry is published when it should not be.'
  end

  test 'publish an entry' do
    entry = entries(:unpublished)
    entry.publish!

    assert entry.published?, 'Entry has not been published when it should be.'
  end

  test 'unpublish an entry' do
    entry = entries(:published)
    entry.unpublish!

    assert !entry.published?, 'Entry is still published when it should not be.'
  end

  test 'should ensure that there is only one primary thumbnail' do
    entry = entries(:one)
    entry.attachments.build(category: 'Primary Thumbnail')
    entry.attachments.build(category: 'Primary Thumbnail')
    entry.save
    assert entry.errors[:attachments].count.positive?, 'Did not generate any errors about attachments'
  end

  test 'is the entry archived?' do
    archived = entries(:archived)
    entry = entries(:one)

    assert archived.archived?, 'Entry should have been archived'
    assert_not entry.archived?, 'Entry should not be archived'
  end

  test 'should have archived flag in the elastic search search data' do
    entry = entries(:one)
    assert entry.search_data.keys.include?('archived?'), 'Did not find archived flag in ES search data'
  end

  test 'should archive entry' do
    entry = entries(:one)
    user = users(:one)

    assert_difference('ArchiveItem.count') do
      entry.archive!('Testing archiving', user)
    end
  end

  test 'should unarchive entry' do
    entry = entries(:archived)

    assert_difference('ArchiveItem.count', -1) do
      entry.unarchive!
    end
  end

  test 'should return changed activity hash' do
    entry = entries(:one)

    entry.title = 'Testing change to title'
    data = { display: entry.title }
    assert_equal data, entry.changed_activity('title')
    assert_nil entry.changed_activity('description')
  end

  test 'should return changed fields' do
    entry = entries(:one)

    entry.title = 'Testing change to title'
    entry.description = 'Non id dolore quis fore, ea et esse veniam culpa. Sunt laborum e expetendis. Ne
    o veniam illum enim, irure laboris cohaerescant an senserit sint iis ullamco
    comprehenderit o qui qui aute consequat. Quo o ipsum nostrud ubi iudicem ut
    arbitror te export expetendis relinqueret non appellat amet aute eu veniam non e
    nisi admodum an est elit quem est singulis, admodum multos elit ea quis ne
    eiusmod se expetendis.Commodo noster consequat officia, voluptate quae quae ne
    magna eu elit ex consequat aut tempor, arbitror esse constias mandaremus. Se
    irure probant relinqueret ex legam nam arbitror de iis fore culpa export
    consequat, offendit tempor pariatur a iis an fore appellat, labore arbitror ubi
    ingeniis, litteris ad nescius est te quae aliquip arbitrantur. O nulla amet iis
    cernantur ea arbitror do mandaremus.'

    assert_includes entry.activity_params, :title
    assert_includes entry.activity_params, :description
    assert_not_includes entry.activity_params, :start_date
    assert_equal entry.description[0..50], entry.activity_params[:description][:display]
  end
end
