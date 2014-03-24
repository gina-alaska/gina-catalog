class Manager::CatalogsController < ManagerController
  include CatalogConcerns::Search
  
  skip_before_filter :authenticate_manager!, only: [:share]
  before_filter :authenticate_access_catalog!, except: [:share]
#  before_filter :authenticate_access_cms!
  before_filter :authenticate_edit_records!, only: [:edit, :new, :create, :update]
  before_filter :authenticate_publish_records!, only: [:unpublish, :publish]
  before_filter :fetch_record, :except => [:index, :create, :new, :toggle_collection, :share]
  before_filter :restrict_to_current_setup, :except => [:index, :create, :new, :toggle_collection, :show, :share]
  
  SUBMENU = '/layouts/manager/catalog_menu'
  PAGETITLE = 'Data Records'
  
  respond_to :html
  
  def index
    @page = params[:page] || 1
    @limit = 50
    @sort = params[:sort] || ''
    @sortdir = params[:sort_direction] || "ascending"

    @search = search_params(params[:search])

    advanced_opts = @search.reject { |k,v| v.blank? or ['q', 'collection_id', 'order_by', 'sds', 'unpublished', 'editable'].include?(k) }
    @is_advanced = advanced_opts.keys.size > 0

    search = solr_search(@search, @page, @limit)
    if search.respond_to? :results
      @catalogs = search.results
      @total = search.total
    else
      @catalogs = Array.wrap(search)
      @total = 0
    end
    
    respond_with @catalogs
  end
  
  def show
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @catalog = Catalog.new
    @catalog.links.build
    @catalog.locations.build
    @catalog.download_urls.build
    
    respond_to do |format|
      format.html
    end
  end
  
  def download
    if @catalog.repo and @catalog.repo.archive_available?(:zip)
      send_file @catalog.repo.archive_filenames[:zip]
    else
      respond_to do |format|
        format.html { render 'public/404', :status => 404 }
      end
    end
  end
  
  def create
    @catalog = Catalog.new(catalog_params)
    @catalog.owner_setup = current_setup
    @catalog.setups << current_setup
    
    if @catalog.save
      respond_to do |format|
        format.html {
          flash[:success] = 'Created catalog record'
          redirect_to [:manager, @catalog]
        }
      end
    else
      respond_to do |format|
        format.html {
          render 'new'
        }
      end
    end
  end
  
  def edit
    @catalog.links.build
    @catalog.locations.build
    @catalog.download_urls.build
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    if @catalog.update_attributes(catalog_params)
      respond_to do |format|
        format.html {
          flash[:success] = 'Updated catalog record'
          redirect_to [:manager, @catalog]
        }
      end
    else
      respond_to do |format|
        format.html {
          render 'edit'
        }
      end
    end
  end
  
  def unpublish
    respond_to do |format|
      if @catalog.unpublish
        flash.now[:success] = 'Successfully unpublished record'
        format.js { render 'share' }
      else
        flash.now[:error] = 'Unable to unpublish record'
        format.js { render 'share' }
      end
    end
  end
  
  def publish
    respond_to do |format|
      if @catalog.publish(current_user)
        flash.now[:success] = 'Successfully published record'
        format.js { render 'share' }
      else
        flash.now[:error] = 'Unable to publish record'
        format.js { render 'share' }
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if @catalog.archive
        format.html { 
          flash[:success] = "#{@catalog} has been archived"
          redirect_to manager_catalogs_path
        }
      else
        format.html { 
          flash[:error] = "Error while trying to archive #{@catalog}"
          redirect_to @catalog
        }
      end
    end
  end
  
  def share
    @catalog = Catalog.find(params[:id])
    @setup = Setup.find(params[:setup_id])
    
    membership = current_user.memberships.where(setup_id: @setup.id).first
    
    if user_signed_in? and membership and membership.can_manage_catalog?
      if @catalog.setups.where(id: @setup.id).any?
        if @catalog.owner_setup == @setup
          flash.now[:error] = "Cannot be unshared the record from this portal, it is the current owner of the record"          
        elsif @catalog.owner_setup.ancestors.include?(@setup)
          flash.now[:error] = "Cannot be unshared the record from this portal, it is automatically shared with all parent portals"
        else
          @catalog.setups.destroy(@setup.id)
          flash.now[:success] = "Unshared catalog record from portal #{@setup.full_title}"
        end
      else
        @catalog.setups << @setup
        if @catalog.save
          flash.now[:success] = "Shared catalog record to #{@setup.full_title}"
        else
          flash.now[:error] = "Error while trying to share catalog record to #{@setup.full_title}"
        end
      end
    else
      flash.now[:error] = "You do not have permission to share records"
    end
    
    respond_to do |format|
      format.js
    end
  end

  protected
  
  def catalog_params
    v = params[:catalog].slice(:title, :description, :start_date, :end_date, :status, 
      :owner_id, :primary_contact_id, :contact_ids, :source_agency_id, :funding_agency_id, :data_type_ids,
      :iso_topic_ids, :agency_ids, :tags, :geokeyword_ids, :collection_ids, :type, :links_attributes,
      :locations_attributes, :download_urls_attributes, :use_agreement_id, :request_contact_info, :require_contact_info)
    
    
    v['collection_ids'] = clean_param_ids(v['collection_ids'])
    v['agency_ids'] = clean_param_ids(v['agency_ids'])
    v['geokeyword_ids'] = clean_param_ids(v['geokeyword_ids'])
    v['data_type_ids'] = clean_param_ids(v['data_type_ids'])
    v['iso_topic_ids'] = clean_param_ids(v['iso_topic_ids'])
    v['contact_ids'] = clean_param_ids(v['contact_ids'])
    
      
    v
  end
  
  def clean_param_ids(ids)
    return nil if ids.nil?
    ids.map(&:to_i).reject { |i| i == 0 }
  end
  
  def split_word_list(key, params)
    if params[key]
      list = params.delete(key)
      params[key] = list.split(/,\s*/).uniq.compact
    end
  end
  
  def fetch_record
    @catalog = Catalog.includes(:links, :locations, :agencies, :geokeywords, :people).find(params[:id])
  end
  
  def restrict_to_current_setup
    if fetch_record.owner_setup != current_setup
      flash[:warning] = "This record can only be managed from the #{@catalog.owner_setup.title} portal"
      redirect_to manager_catalog_path(@catalog)
    end
  end
end
