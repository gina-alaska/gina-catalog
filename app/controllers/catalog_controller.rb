class CatalogController < ApplicationController
  # caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  # caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }
  #caches_action :search
  
  def create
    if(params[:type].downcase == 'project') 
      @item = Project.new(catalog)
    else
      @item = Asset.new(catalog)
    end
    
    if @item.save
      respond_to do |format|
        format.json {
          render :json => {
            :success => true,
            :catalog => @item
          }
        }
      end
    else
      respond_to do |format|
        format.json {
          render :json => {
            :success => false,
            :errors => @item.errors.full_messages
          }
        }
      end
    end
  end

  def update
    @item = Catalog.where(:id => params[:id]).includes(:agencies, :tags, :geokeywords).first
    
    if @item.update_attributes(catalog)    
      respond_to do |format|
        format.json { 
          render :json => {
            :success => true,
            :catalog => @item
          }
        }
      end
    else
      respond_to do |format|
        format.json { 
          render :json => {
            :success => false,
            :errors => @item.errors.full_messages
          }
        }
      end      
    end
  end

  def show
    @item = Catalog.includes(:locations, :source_agency, :agencies, :data_source, :links, :tags, :geokeywords)
    @item = @item.includes({ :people => [ :addresses, :phone_numbers ] }).find_by_id(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render :json => @item.as_json(:format => 'full') }
      format.tar_gz do
        render :content_type => "application/octet-stream", :layout => false, 
          :text => @item.repo.archive_tar_gz('master', "#{@item.id}/")
      end
      format.zip do
        render :content_type => "application/octet-stream", :layout => false, 
          :text => @item.repo.archive_zip('master', "#{@item.id}/")
      end
    end
  end

  def search
    search = params[:search] || []
    
    # Handle the filters from the standard extjs data stores
    if params[:filter]
      JSON.parse(params[:filter]).each do |f|
        search[f["property"]] = f["value"]
      end
    end
    
    # Handle the sorting from the standard extjs data stores
    if params[:sort]
      s = JSON.parse(params[:sort]).first 
      field, direction = s["property"], s["direction"].downcase.to_sym
      
      # Custom sort field for title, extjs isn't able to specify one 
      # in it's config so we have to munge it here
      field = 'title_sort' if field == 'title'
    end
    
    
#    if(params[:q].nil? or params[:q].empty?)
#      results = sphinx_search('', params[:sort], params[:dir], params[:start], params[:limit])
#    else
#      results = sphinx_search(params[:q], params[:sort], params[:dir], params[:start], params[:limit])
#    end
#    results = Project.search('', :per_page => 3000)
#    @results = Catalog.not_archived.published
#    @results = @results.includes(:locations, :source_agency, :people, :agencies, :tags, :geokeywords)
#    @results = @results.where(:id => params[:ids]) unless params[:ids].nil?
#    @results = @results.limit(params[:limit] || 3000).order('title ASC')
    
    table_includes = [:tags, :locations, :agencies, :source_agency]
    
    if(search.nil? or search.empty?)
      @results = Catalog.not_archived.published
      @results = @results.includes(table_includes)
      @results = @results.where(:id => params[:ids]) unless params[:ids].nil?
      @results = @results.paginate(:page => params[:page], :per_page => params[:limit] || 3000).order('title ASC')
      @results = [] if Rails.env == 'development'
      @total = @results.count
    else  
      catalog_ids = search[:ids] unless search[:ids].nil? or search[:ids].empty?
      
      if(!catalog_ids and search[:bbox])
        # catalog_ids = []
        # catalog_ids += Catalog.geokeyword_intersects(bbox).pluck('catalog.id').uniq
        catalog_ids = Catalog.location_intersects(search[:bbox]).select('distinct catalog.id').collect(&:id)
        catalog_ids.uniq!
      end

      if search[:order_by]
        field, direction = search[:order_by].split("-");
        direction ||= :asc
      end

      @search = Sunspot.search(Project, Asset) do
        adjust_solr_params do |params|
          # Force solar to do an 'OR'ish search, at least 1 "optional" word is required in each  
          # ocean marine sea    ~> ocean OR marine OR sea
          # ocean marine +sea   ~> (ocean AND sea) OR (marine AND sea)
          # ocean +marine +sea  ~> ocean AND marine AND sea
          params[:mm] = "1"
          params[:ps] = 1
          params[:pf] = [:title, :description]
        end

        data_accessor_for(Project).include=table_includes
        data_accessor_for(Asset).include=table_includes
        fulltext search[:q]
        with :id, catalog_ids unless catalog_ids.nil? or catalog_ids.empty?
        with :status, search[:status] if search[:status]
        with :long_term_monitoring, ((search[:long_term_monitoring].to_i > 0) ? true : false) if search.include? :long_term_monitoring
        with :archived_at_year, nil unless search[:archived]
        with :type, search[:type] if search[:type]
        with :agency_ids, search[:agency_ids] if search[:agency_ids]
        with :source_agency_id, search[:source_agency_id] if search[:source_agency_id]
        with :iso_topic_ids, search[:iso_topic_ids] if search[:iso_topic_ids]
        with :contact_id, search[:contact_id] if search[:contact_id]
        with :geokeywords_name, search[:region] if search[:region]
        with(:start_date_year).greater_than(search[:start_date_after]) if search[:start_date_after]

        with(:start_date_year).less_than(search[:start_date_before]) if search[:start_date_before]

        with(:end_date_year).greater_than(search[:end_date_after]) if search[:end_date_after]
        
        with(:end_date_year).less_than(search[:end_date_before]) if search[:end_date_before]

        paginate per_page:(params[:limit] || 3000), page:(params[:page] || 1)
        
        order_by(field, direction) if field and direction
      end
      
      @results = @search.results
      @total = @search.total
    end
    
    respond_to do |format|
      format.json
      format.js
      format.html do
        render :layout => 'pdf'
      end
      format.pdf do
        render :pdf => 'nssi_catalog_search.pdf', :layout => 'pdf.html'
      end
    end
  end
  
  protected
  
  def catalog
    v = params.slice(
          :title, :description, :agengy_ids, :tags, :source_agency_id, :status,
          :geokeyword_ids, :links_attributes,
          :agency_ids, :person_ids, :iso_topic_ids, :start_date, :end_date, :long_term_monitoring, 
    )    
    v["tags"] = v["tags"].split(/,\s+/)
    
    v
  end
end
