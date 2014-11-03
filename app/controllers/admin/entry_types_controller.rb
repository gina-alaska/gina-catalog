class Admin::EntryTypesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  protected
  
  def entry_type_params
    params.require(:entry_type).permit(:name, :description, :color)
  end
end
