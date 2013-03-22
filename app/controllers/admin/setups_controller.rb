class Admin::SetupsController < AdminController
  def index
    @setups = Setup.all
  end
end
