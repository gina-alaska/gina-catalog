class Catalog::EntriesController < CatalogController
  before_action :set_entry
  before_action :set_cms_page
  before_action :gather_use_agreements, only: [:new, :create, :edit, :update]
  before_action :set_activities, only: [:show, :map]
  authorize_resource

  layout 'pages', only: [:show, :index]

  include EntriesControllerSearchConcerns

  def index
    respond_to do |format|
      format.html { search(params[:page], params[:limit] || 20) }
      format.geojson { search(params[:page], params[:limit] || 500) }
      # format.json
    end
  end

  def show
    @archive_item = ArchiveItem.new
    @downloads = DownloadLog.where(entry: @entry).page(params[:page]).per(20)

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
      format.html {
        render layout: 'map'
      }
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

  def exports
    @search_params = JSON.parse(params["serialized_search"]).symbolize_keys

    respond_to do |format|
      format.html { search(params[:page], params[:limit] || 20) }
      format.geojson { search(params[:page], params[:limit] || 500) }
      format.json
    end
  end

  protected

  def entry_params
    values = params.require(:entry).permit(
      :title, :description, :status, :entry_type_id, :start_date, :end_date,
      :use_agreement_id, :request_contact_info, :require_contact_info,
      :tag_list,
      collection_ids: [], region_ids: [], iso_topic_ids: [], data_type_ids: [],
      links_attributes: [:id, :link_id, :category, :display_text, :url, :_destroy],
      entry_collections_attributes: [:id, :_destroy],
      attachments_attributes: [:id, :file, :category, :description, :interaction, :_destroy],
      entry_contacts_attributes: [:id, :contact_id, :primary, :_destroy],
      entry_organizations_attributes: [:id, :organization_id, :primary, :funding, :_destroy],
      entry_map_layers_attributes: [:id, :map_layer_id, :_destroy])

    if values[:collection_ids].present?
      values[:collection_ids] = values.delete(:collection_ids).map(&:to_i).reject { |v| v == 0 }
    end

    if values[:region_ids].present?
      values[:region_ids] = values.delete(:region_ids).map(&:to_i).reject { |v| v == 0 }
    end

    if values[:iso_topic_ids].present?
      values[:iso_topic_ids] = values.delete(:iso_topic_ids).map(&:to_i).reject { |v| v == 0 }
    end

    if values[:data_type_ids].present?
      values[:data_type_ids] = values.delete(:data_type_ids).map(&:to_i).reject { |v| v == 0 }
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
