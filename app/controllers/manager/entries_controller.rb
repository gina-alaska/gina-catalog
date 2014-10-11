class Manager::EntriesController < ApplicationController
  load_and_authorize_resource

  def index
    @entries = Entry.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @entry.sites << current_site
    respond_to do |format|
      if @entry.save
        flash[:success] = "Entry #{@entry.title} was successfully created."
        format.html { redirect_to manager_entries_path }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @entry.update_attributes(entry_params)
        flash[:success] = "Entry #{@entry.title} was successfully updated."
        format.html { redirect_to manager_entries_path }
        format.json { head :nocontent }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry.destroy

    respond_to do |format|
      flash[:success] = "Entry #{@entry.title} was successfully deleted."
      format.html { redirect_to manager_entries_path }
      format.json { head :no_content }
    end
  end
  
  protected
  
  def entry_params
    params.require(:entry).permit(:title, :description, :status, :start_date, :end_date)
  end
end
