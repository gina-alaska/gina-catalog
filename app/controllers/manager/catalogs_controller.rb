class Manager::CatalogsController < ManagerController
  before_filter :fetch_record, :except => [:index, :create, :new, :toggle_collection]
  
  include CatalogConcerns::Search
  
  respond_to :html
  
  def index
    @page = params[:page] || 1
    @limit = 50
    @search = params[:search] || {}
    @search[:order_by] ||= 'title_sort-ascending'
    if @search.keys.count > 0
      search = solr_search(@search, @page, @limit)
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
  
  def create
    @catalog = Catalog.new(catalog_params)
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
  
  protected
  
  def catalog_params
    v = params[:catalog].slice(:title, :description, :start_date, :end_date, :status, 
      :owner_id, :primary_contact_id, :people_ids, :source_agency_id, :funding_agency_id, 
      :agency_ids, :tags, :geokeywords, :catalog_collection_ids, :type, :links_attributes, :locations_attributes)
    
    
    v['catalog_collection_ids'] = clean_param_ids(v['catalog_collection_ids'])
    v['agency_ids'] = clean_param_ids(v['agency_ids'])
    # v['people_ids'] = clean_param_ids(v['people_ids'])
    
      
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
end
