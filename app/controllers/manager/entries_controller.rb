class Manager::EntriesController < ApplicationController
  load_and_authorize_resource

  def index
    @entries = Entry.joins(:entry_sites).where(entry_sites: { site_id: current_site.self_and_descendants })
  end

  def show
  end

  def new
    @entry.links.build
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
    params.require(:entry).permit(:title, :description, :status, :start_date, :end_date, :use_agreement_id, :request_contact_info, :require_contact_info, entry_contacts_attributes: [:id, :contact_id, :primary, :secondary, :_destroy])
  end
end
