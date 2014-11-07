class Manager::EntriesController < ApplicationController
  load_and_authorize_resource

  def index
    @entries = Entry.joins(:entry_portals).where(entry_portals: { portal_id: current_portal.self_and_descendants })
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @entry.portals << current_portal
    respond_to do |format|
      if @entry.save
        flash[:success] = "Catalog record #{@entry.title} was successfully created."
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
        flash[:success] = "Catalog record #{@entry.title} was successfully updated."
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
      flash[:success] = "Catalog record #{@entry.title} was successfully deleted."
      format.html { redirect_to manager_entries_path }
      format.json { head :no_content }
    end
  end
  
  protected
  
  def entry_params
    params.require(:entry).permit(:title, :description, :status, :entry_type_id, :start_date, :end_date, :use_agreement_id, :request_contact_info, :require_contact_info, entry_contacts_attributes: [:id, :contact_id, :primary, :secondary, :_destroy], entry_agencies_attributes: [:id, :agency_id, :primary, :funding, :_destroy])
  end
end
