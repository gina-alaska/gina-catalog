require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  should ensure_length_of(:name).is_at_most(255)

  should validate_uniqueness_of(:name)

  test "WKT point should intersect polygons" do
    regions = Region.intersects("POINT(5 5)")

    assert_equal 2, regions.count
  end

  test "WKT point should not intersect polygons" do
    regions = Region.intersects("POINT(20 20)")

    assert_equal 0, regions.count
  end
end
