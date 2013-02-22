class Manager::DataController < ManagerController
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
  
  def edit
    respond_to do |format|
      format.html
    end
  end
  
  def update
    if @catalog.update_attributes(catalog_params(@catalog.type))
      respond_to do |format|
        format.html {
          flash[:success] = 'Updated catalog record'
          redirect_to manager_datum_path(@catalog)
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
  
  def catalog_params(type)    
    v = params[type.downcase.to_sym].slice(:title, :description, :start_date, :end_date, :status, 
      :owner_id, :primary_contact_id, :people_ids, :source_agency_id, :funding_agency_id, 
      :agency_ids, :tags, :geokeywords, :catalog_collection_ids)
     
    v['catalog_collection_ids'] = v['catalog_collection_ids'].map(&:to_i).reject { |i| i == 0 }
      
    v
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
