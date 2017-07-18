require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  should have_one(:membership)
  should have_many(:authorizations)
  should have_many(:permissions)
  should have_many(:portals).through(:permissions)
  should have_many(:activity_logs)

  test 'user should have all privs for portal one' do
    @user = users(:one)
    @portal = portals(:one)

    manager = %w(cms_manager data_manager portal_manager)
    manager.each do |role|
      assert @user.role?(role, @portal), "User was not a #{role} when they should have been"
    end
  end

  test 'user should have no privs for portal two' do
    @user = users(:one)
    @portal = portals(:two)

    manager = %w(cms_manager data_manager portal_manager)

    manager.each do |role|
      assert !@user.role?(role, @portal), "User was a #{role} when they should not have been"
    end
  end

  test 'adding permissions to a new user' do
    user = users(:one)
    @user = User.new(name: user.name, email: user.email)
    @portal = portals(:one)

    @user.set_roles(@portal, cms_manager: false)
  end
end
