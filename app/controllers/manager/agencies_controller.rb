class Manager::AgenciesController < ApplicationController
  load_and_authorize_resource

  def index
    @agencies = Agency.all

    respond_to do |format|
      format.html
      format.json { render json: @agencies }
    end
  end

  #def show
  #end

  def new
    @agency = Agency.new
    @agency.aliases.build
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
