class UsersController < ApplicationController
  #layout 'pdf'
  respond_to :json, :html

  def index
    if params[:query].nil? or params[:query].empty?
      @users = User.includes(:roles).all
    else
      search = User.search do
        fulltext params[:query]
      end
      
      @users = search.results
    end

    respond_with({ :users => @users })
  end

  def preferences
    respond_with({ :user => current_user })
  end
end
