require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  should validate_length_of(:name).is_at_most(255)

  should validate_uniqueness_of(:name)

  test 'WKT point should intersect polygons' do
    regions = Region.intersects('POINT(4 4)')

    assert_equal 1, regions.count
  end

  test 'WKT point should not intersect polygons' do
    regions = Region.intersects('POINT(20 20)')

    assert_equal 0, regions.count
  end

  test 'check for deletable' do
    region = regions(:no_associated_entry)
    assert region.deletable?, 'Region is marked as undeletable when it should be deletable.'
  end

  test 'check for undeletable' do
    region = regions(:one)
    region.entries << entries(:one)

    assert !region.deletable?, 'Region is marked as deletable but it should not be'
  end
end
