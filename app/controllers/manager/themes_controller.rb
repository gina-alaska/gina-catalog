class Manager::ThemesController < ManagerController
  before_filter :authenticate_access_cms!
  
  def index
  end
end
