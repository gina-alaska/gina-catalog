class Manager::EntriesController < ApplicationController
  load_and_authorize_resource

  include EntriesControllerSearchConcerns

  def index
    respond_to do |format|
      format.html { search(params[:page]) }
      format.geojson { search(1, 10_000) }
      format.json
    end
  end

  def show
    redirect_to @entry
  end

  def new
    @entry.attachments.build
    @entry.links.build
    @use_agreements = UseAgreement.where(archived_at: nil) || []
  end

  def edit
    @entry.attachments.build
    @entry.links.build
    @use_agreements = UseAgreement.where(archived_at: nil) || []
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

  def collections
    @collections = current_portal.collections.order(:name)
    if params[:q].present?
      @collections = @collections.where('name ilike ?', "%#{params[:q]}%")
    end
  end

  def tags
    @tags = Entry.all_tags.order(:name)
    if params[:q].present?
      @tags = @tags.where('name ilike ?', "%#{params[:q]}%")
    end
  end

  protected

  def entry_params
    values = params.require(:entry).permit(
      :title, :description, :status, :entry_type_id, :start_date, :end_date,
      :use_agreement_id, :request_contact_info, :require_contact_info, :tag_list,
      :collection_ids => [], :region_ids => [],
      links_attributes: [:id, :link_id, :category, :display_text, :url, :_destroy],
      attachments_attributes: [:id, :file, :category, :description, :interaction, :_destroy],
      entry_contacts_attributes: [:id, :contact_id, :primary, :_destroy],
      entry_organizations_attributes: [:id, :organization_id, :primary, :funding, :_destroy])

    if values[:collection_ids].present?
      values[:collection_ids] = values.delete(:collection_ids).map(&:to_i).reject { |v| v == 0 }
    end

    if values[:region_ids].present?
      values[:region_ids] = values.delete(:region_ids).map(&:to_i).reject { |v| v == 0 }
    end

    values
  end
end
