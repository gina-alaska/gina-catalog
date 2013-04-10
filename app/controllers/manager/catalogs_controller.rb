class Manager::CatalogsController < ManagerController
  before_filter :authenticate_access_catalog!
#  before_filter :authenticate_access_cms!
  before_filter :authenticate_edit_records!, only: [:edit, :new, :create, :update]
  before_filter :authenticate_publish_records!, only: [:unpublish, :publish]
  before_filter :fetch_record, :except => [:index, :create, :new, :toggle_collection]
  before_filter :restrict_to_current_setup, :except => [:index, :create, :new, :toggle_collection, :show]
  
  SUBMENU = '/layouts/manager/catalog_menu'
  PAGETITLE = 'Data Records'
  
  include CatalogConcerns::Search
  
  respond_to :html
  
  def index
    @page = params[:page] || 1
    @limit = 50
    @search = params[:search] || {}
    @search[:order_by] ||= 'title_sort-ascending'
    if @search.keys.count > 0
      search = solr_search(@search, @page, @limit, true)
      @catalogs = search.results
    else
      @catalogs = Catalog.order('title ASC').page(@page).per(@limit)
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
    
    respond_to do |format|
      format.html
    end
  end
  
  def download
    if @catalog.repo.archive_available?(:zip)
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
        format.html {
          flash[:success] = 'Successfully published record'
          redirect_to [:manager, @catalog]
        }
      else
        format.html {
          flash[:error] = 'Unable to publish record'
          redirect_to [:manager, @catalog]
        }
      end
    end
  end
  
  def publish
    respond_to do |format|
      if @catalog.publish(current_user)
        format.html {
          flash[:success] = 'Successfully published record'
          redirect_to [:manager, @catalog]
        }
      else
        format.html {
          flash[:error] = 'Unable to publish record'
          redirect_to [:manager, @catalog]
        }
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
  
  protected
  
  def authenticate_edit_records!
    unless user_is_a_member? and current_member.can_manage_catalog?
      authenticate_user!
    end
  end  
  
  def authenticate_publish_records!
    unless user_is_a_member? and current_member.can_publish_catalog?
      authenticate_user!
    end
  end
  
  def catalog_params
    v = params[:catalog].slice(:title, :description, :start_date, :end_date, :status, 
      :owner_id, :primary_contact_id, :person_ids, :source_agency_id, :funding_agency_id, :data_type_ids,
      :iso_topic_ids, :agency_ids, :tags, :geokeyword_ids, :catalog_collection_ids, :type, :links_attributes,
      :locations_attributes, :download_urls_attributes)
    
    
    v['catalog_collection_ids'] = clean_param_ids(v['catalog_collection_ids'])
    v['agency_ids'] = clean_param_ids(v['agency_ids'])
    v['geokeyword_ids'] = clean_param_ids(v['geokeyword_ids'])
    v['data_type_ids'] = clean_param_ids(v['data_type_ids'])
    v['iso_topic_ids'] = clean_param_ids(v['iso_topic_ids'])
    v['person_ids'] = clean_param_ids(v['person_ids'])
    
      
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
    @catalog = Catalog.includes(:tags, :links, :locations, :agencies, :geokeywords, :people).find(params[:id])
  end
  
  def restrict_to_current_setup
    if fetch_record.owner_setup != current_setup
      flash[:warning] = "This record can only be managed from the #{@catalog.owner_setup.title} portal"
      redirect_to manager_catalog_path(@catalog)
    end
  end
end
