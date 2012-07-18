class Admin::UsersController < AdminController
  def index
    if params[:q] and !params[:q].empty?
      search = User.search do
        fulltext params[:q]
        order_by 'last_name', :asc
      end
      @users = search.results
    else
      @users = User.includes(:roles).order('last_name ASC, first_name ASC').all
    end
  end
  
  def show
    @user = fetch_user
  end
  
  protected
  
  def fetch_user
    User.includes(:roles).find(params[:id])
  end
end
