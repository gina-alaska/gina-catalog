require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  should have_one(:membership)
  should have_many(:authorizations)
  should have_many(:site_users)
  should have_many(:sites).through(:site_users)
  
  def setup
  end
  
  test "user should have all manager privs for a site"  do
    @user = users(:one)
    @site = sites(:one)
    
    User.available_roles.each do |role|
      assert @user.is_a?(role, @site), "User was not a #{role} when they should have been"
    end
  end
  
  test "user should have no manager privs for a site"  do
    @user = users(:one)
    @site = sites(:two)
    
    User.available_roles.each do |role|
      assert !@user.is_a?(role, @site), "User was a #{role} when they should not have been"
    end
  end
end
