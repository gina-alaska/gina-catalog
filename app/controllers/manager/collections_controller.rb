class Manager::CollectionsController < ApplicationController
  def index
    @collections = Collection.all

    respond_to do |format|
      format.html
      format.json { render json: @collections }
    end
  end

  def show
  end

  def new
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
