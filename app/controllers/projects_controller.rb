class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
#    @project = @project.includes(:primary_contact => [:phone_numbers, :addresses])
#    @project = @project.includes(:synopsis, :links, :tags, :locations)
  end
end
