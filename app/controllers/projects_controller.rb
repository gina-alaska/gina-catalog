class ProjectsController < ApplicationController
  caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }

  def show
    @project = Project.find(params[:id])
#    @project = @project.includes(:primary_contact => [:phone_numbers, :addresses])
#    @project = @project.includes(:synopsis, :links, :tags, :locations)

    render :layout => false
  end
end
