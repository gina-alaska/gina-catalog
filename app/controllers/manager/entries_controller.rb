class Manager::EntriesController < ApplicationController
  before_action :gather_use_agreements, only: [:new, :create, :edit, :update]
  load_and_authorize_resource

  include EntriesControllerSearchConcerns

  def index
    respond_to do |format|
      format.html { search(params[:page], params[:limit] || 20) }
      format.geojson { search(1, 10000) }
      format.json
    end
  end

  def show
    redirect_to @entry
  end

  def new
    @entry.attachments.build
    @entry.links.build
  end

  def edit
    @entry.attachments.build
    @entry.links.build
  end

  def create
    @entry.portals << current_portal
    respond_to do |format|
      if @entry.save
        flash[:success] = "Catalog record #{@entry.title} was successfully created."

        if params['commit'] == 'Save'
          format.html { redirect_to edit_manager_entry_path(@entry) }
          format.js { redirect_via_turbolinks_to edit_manager_entry_path(@entry) }
        else
          format.html { redirect_to manager_entries_path }
          format.js { redirect_via_turbolinks_to manager_entries_path }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
        format.js do
          flash.now[:error] = @entry.errors.full_messages
          render 'form_response'
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @entry.update_attributes(entry_params)

        flash[:success] = "Catalog record #{@entry.title} was successfully updated."

        if params['commit'] == 'Save'
          format.html { redirect_to edit_manager_entry_path(@entry) }
          format.js { redirect_via_turbolinks_to edit_manager_entry_path(@entry) }
        else
          format.html { redirect_to manager_entries_path }
          format.js { redirect_via_turbolinks_to manager_entries_path }
        end
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
        format.js do
          flash.now[:error] = @entry.errors.full_messages
          render 'form_response'
        end
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
    values = params.require(:entry).permit(
      :title, :description, :status, :entry_type_id, :start_date, :end_date,
      :use_agreement_id, :request_contact_info, :require_contact_info, :tag_list,
      collection_ids: [],
      links_attributes: [:id, :link_id, :category, :display_text, :url, :_destroy],
      attachments_attributes: [:id, :file, :category, :description, :interaction, :_destroy],
      entry_contacts_attributes: [:id, :contact_id, :primary, :_destroy],
      entry_organizations_attributes: [:id, :organization_id, :primary, :funding, :_destroy])

    if values[:collection_ids].present?
      values[:collection_ids] = values.delete(:collection_ids).map(&:to_i).reject { |v| v == 0 }
    end
    values
  end

  def gather_use_agreements
    @use_agreements = UseAgreement.where(archived_at: nil) || []
  end
end
