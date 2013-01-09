class Manager::DataController < ApplicationController
  layout 'manager'
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
end
