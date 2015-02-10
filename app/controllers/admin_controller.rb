# there should be no actions that go here!!
class AdminController < ApplicationController
  skip_before_action :check_current_portal

  layout 'admin'
end
