class ReposController < ApplicationController
  respond_to :html
  
  before_filter :handle_git_format
  
  def show
    @repo = Repo.where(:slug => params[:id]).first
    
    respond_with(@repo)
  end
  
  protected
  
  def handle_git_format
    request.format = :html if request.format == :git
  end
end
