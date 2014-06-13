class SearchesController < ApplicationController
  include CatalogConcerns::Search

  def show
    @agencies = Agency.select([:name,:id]).collect{|a| [a.name, a.id]}.group_by{|a| a.first.first }
     #Agency.all #.group_by{|a| a.name[0]}
    setup_ids = current_setup.self_and_descendants.pluck(:id)
    source_catalogs = Catalog.joins(:setups).where(setups: {id: setup_ids}).uniq.pluck(:owner_setup_id)
    @sources = Setup.where(id: source_catalogs).order(:title).collect{|a| [a.title, a.id]}

    search_catalog
    
    respond_to do |format|
      format.html do
        render layout: "search"
      end
      format.json
      format.js
    end
  end
  
  def unique
    params[:limit] = 100000
    @search = solr_search
    u = @search.hits.group_by{|h| h.stored(:title)}
    @unique_total = u.try(:count)
    types = u.collect{|k,v| v.first}.group_by(&:class_name)
  #  types = @search.hits.group_by{|h| h.class_name}
    @projects = types["Project"].try(:count)
    @assets = types["Asset"].try(:count)

    respond_to do |format|
      format.json
    end
  end

  def export
    search_catalog

    respond_to do |format|
      format.html do
        render layout: "pdf"
      end

      format.json

      format.pdf do
        render :pdf => "catalog-#{Time.now.strftime("%Y%m%d")}.pdf", :layout => 'pdf.html'
      end

      format.csv do
        filename = "catalog-#{Time.now.strftime("%Y%m%d")}.csv"
        if request.env['HTTP_USER_AGENT'] =~ /msie/i
          # headers['Pragma'] = 'public'
          headers["Content-type"] = "text/csv" 
          # headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
          headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
          # headers['Expires'] = "0" 
        else
          headers["Content-Type"] ||= 'text/csv'
          headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
        end
        render layout: false
      end
    end
  end

  protected

  def search_catalog
    @search_params = search_params(params[:search])
    @format = params[:format] || ""
    @limit = params[:limit] || 30
    @pagenum = params[:page] || 1
    
    advanced_opts = @search_params.reject { |k,v| v.blank? or ['q', 'collection_ids', 'order_by', 'limit', 'field', 'direction', 'tags', 'bbox', 'published_only'].include?(k.to_s) }
    @is_advanced = advanced_opts.keys.size > 0
    
    @search = solr_search(@search_params, @pagenum, @limit, :collection_ids)
    if @search.respond_to? :results
      @collection_facets = @search.facet(:collection_ids).rows.inject({}) do |c,v|
        c[v.value] = v.count
        c
      end
      @results = @search.results
      @total = @search.total
    else
      @results = Array.wrap(@search)
      @total = 0
    end
  end
end
