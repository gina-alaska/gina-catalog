require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  should have_one(:membership)
  should have_many(:authorizations)
  should have_many(:site_users)
  should have_many(:sites).through(:site_users)
  
  test "user should have all manager privs for site one"  do
    @user = users(:one)
    @site = sites(:one)
    
    User.available_roles.each do |role|
      assert @user.has_role?(role, @site), "User was not a #{role} when they should have been"
    end
  end
  
  test "user should have no manager privs for site two"  do
    @user = users(:one)
    @site = sites(:two)
    
    User.available_roles.each do |role|
      assert !@user.has_role?(role, @site), "User was a #{role} when they should not have been"
    end
  end
  
  test "adding permissions to a new user" do
    user = users(:one)
    @user = User.new(name: user.name, email: user.email)
    @site = sites(:one)
    
    @user.set_roles(@site, { cms_manager: false })
  end
end
