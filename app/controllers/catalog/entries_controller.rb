class Catalog::EntriesController < CatalogController
  before_action :set_entry
  before_action :set_cms_page
  before_action :gather_use_agreements, only: %i[new create edit update]
  before_action :set_activities, only: %i[show map]
  authorize_resource

  layout 'pages', only: %i[show index]

  include EntriesControllerSearchConcerns

  def index
    @entry_export = EntryExport.new

    respond_to do |format|
      format.html { search(params[:page], params[:limit] || 20) }
      format.geojson { search(params[:page], params[:limit] || 500) }
      # format.json
    end
  end

  def show
    @archive_item = ArchiveItem.new
    @download_count = DownloadLog.where(entry: @entry).count
    @downloads = DownloadLog.where(entry: @entry).order(created_at: :desc).limit(100)

    respond_to do |format|
      format.html
      format.geojson
      format.js
    end
  end

  def new
    @entry = current_portal.entries.build

    @entry.attachments.build
    @entry.links.build
  end

  def edit
    @entry.attachments.build
    @entry.links.build
  end

  def create
    @entry = current_portal.entries.build(entry_params)
    @entry.portals << current_portal

    respond_to do |format|
      if @entry.save
        flash[:success] = "Catalog record #{@entry.title} was successfully created."
        MetadataExportJob.perform_later @entry

        if params['commit'] == 'Save'
          format.html { redirect_to edit_catalog_entry_path(@entry) }
          format.js { redirect_to edit_catalog_entry_path(@entry) }
        else
          format.html { redirect_to catalog_entry_path(@entry) }
          format.js { redirect_to catalog_entry_path(@entry) }
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
        MetadataExportJob.perform_later @entry

        case params['commit']
        when 'Save'
          format.html { redirect_to edit_catalog_entry_path(@entry) }
          format.js { redirect_to edit_catalog_entry_path(@entry) }
        when 'Save & Close'
          format.html { redirect_to catalog_entry_path(@entry) }
          format.js { redirect_to catalog_entry_path(@entry) }
        else
          format.js
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

  def archive
    @entry.archive!(params[:message], current_user)
    @entry.create_activity(:archive)

    respond_to do |format|
      flash[:success] = "Catalog record #{@entry.title} has been archived."
      format.html { redirect_to catalog_entry_path(@entry) }
      format.json { head :no_content }
    end
  end

  def unarchive
    @entry.unarchive!
    @entry.create_activity(:unarchive)

    respond_to do |format|
      flash[:success] = "Catalog record #{@entry.title} has been restored."
      format.html { redirect_to catalog_entry_path(@entry) }
      format.json { head :no_content }
    end
  end

  def publish
    respond_to do |format|
      if @entry.publish!
        # @entry.activity_logs.create(activity: 'Update', user: current_user, log: { message: "Published by #{current_user.first_name}" })

        flash[:success] = "Catalog record #{@entry.title} has been published."
        format.html { redirect_to catalog_entry_path(@entry) }
        format.json { head :no_content }
      else
        flash[:error] = "Catalog record #{@entry.title} could not be published."
        format.html { redirect_to catalog_entry_path(@entry) }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
        format.js do
          flash.now[:error] = @entry.errors.full_messages
          render 'form_response'
        end
      end
    end
  end

  def unpublish
    respond_to do |format|
      if @entry.unpublish!
        # @entry.activity_logs.create(activity: 'Update', user: current_user, log: { message: "Unpublished by #{current_user.first_name}" })

        flash[:success] = "Catalog record #{@entry.title} has been unpublished."
        format.html { redirect_to catalog_entry_path(@entry) }
        format.json { head :no_content }
      else
        flash[:error] = "Catalog record #{@entry.title} could not be unpublished."
        format.html { render action: '@entry' }
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
      format.html { redirect_to catalog_entries_path }
      format.json { head :no_content }
    end
  end

  def map
    respond_to do |format|
      format.html do
        render layout: 'map'
      end
    end
  end

  def toggle_share
    portal = Portal.find(params['portal'])
    entry = Entry.find(params['id'])

    if portal.entries.include?(entry)
      portal.entry_portals.where(entry_id: entry).first.destroy
      flash[:success] = "Catalog record #{entry.title} was unshared with #{portal.title}."
      entry.create_activity(:unshare)
    else
      portal.entries << entry
      flash[:success] = "Catalog record #{entry.title} was shared with #{portal.title}."
      entry.create_activity(:share)
    end

    respond_to do |format|
      format.html { redirect_to catalog_entry_path(entry) }
      format.js { redirect_to catalog_entry_path(entry) }
    end
  end

  protected

  def entry_params
    values = params.require(:entry).permit(
      :title, :description, :status, :entry_type_id, :start_date, :end_date,
      :use_agreement_id, :request_contact_info, :require_contact_info, :tag_list,
      collection_ids: [], region_ids: [], iso_topic_ids: [], data_type_ids: [],
      links_attributes: %i[id link_id category display_text url _destroy],
      entry_collections_attributes: %i[id _destroy],
      attachments_attributes: %i[id file category description interaction _destroy],
      entry_contacts_attributes: %i[id contact_id primary _destroy],
      entry_organizations_attributes: %i[id organization_id primary funding _destroy],
      entry_map_layers_attributes: %i[id map_layer_id _destroy]
    )

    %w[collection_ids region_ids iso_topic_ids data_type_ids].each do |field|
      next unless values.include?(field.to_sym)
      values[field.to_sym] = values.delete(field.to_sym).map(&:to_i).reject(&:zero?)
    end

    values
  end

  def gather_use_agreements
    @use_agreements = UseAgreement.active
  end

  def set_cms_page
    @cms_page = current_portal.pages.find_by_path('catalog')
  end

  def set_entry
    @entry = Entry.find(params[:id]) if params[:id].present?
  end

  def set_activities
    @activities = PublicActivity::Activity.where(entry_id: @entry.id).order(created_at: :desc).limit(20)
  end
end
