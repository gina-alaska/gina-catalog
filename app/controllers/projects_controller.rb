class ProjectsController < ApplicationController
  def show
    @asset = Project.find(params[:id])
  end
end
