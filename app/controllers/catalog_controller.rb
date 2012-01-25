class CatalogController < ApplicationController
  # caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  # caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }
  #caches_action :search

  def show
    @item = Catalog.includes(:locations, :source_agency, :agencies, :data_source, :links, :tags, :geokeywords)
    @item = @item.includes({ :people => [ :addresses, :phone_numbers ] }).find_by_id(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
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
    if(params[:search].nil? or params[:search].empty? )
      @results = Catalog.not_archived.published
      @results = @results.includes(:locations, :source_agency, :people, :agencies, :tags, :geokeywords)
      @results = @results.where(:id => params[:ids]) unless params[:ids].nil?
      @results = @results.limit(params[:limit] || 3000).order('title ASC')
      @results = []
    else
      search = params[:search]
      table_includes = [:tags, :locations]
      if(search[:bbox])
        bbox = Polygon.from_ewkt(search[:bbox])
        catalog_ids = Geokeyword.intersects(bbox).pluck(:catalog_id).uniq
        catalog_ids += Location.intersects(bbox).pluck(:catalog_id).uniq
        catalog_ids.uniq!
      end
      @search = Sunspot.search(Project, Asset) do
        data_accessor_for(Project).include=table_includes
        data_accessor_for(Asset).include=table_includes
        fulltext search[:q]
        with :id, catalog_ids if catalog_ids
        with :status, search[:status] if search[:status]
        with :archived_at_year, nil unless search[:archived]
        with :type, search[:type] if search[:type]
        with :agency_ids, search[:agency_ids] if search[:agency_ids]
        with :source_id, search[:source_id] if search[:source_id]
        with :contact_id, search[:contact_id] if search[:contact_id]
        with :geokeywords_name, search[:region] if search[:region]
        with(:start_date_year).greater_than(search[:start_date_after]) if search[:start_date_after]

        with(:start_date_year).less_than(search[:start_date_after]) if search[:start_date_before]

        with(:end_date_year).greater_than(search[:start_date_after]) if search[:end_date_after]
        
        with(:end_date_year).less_than(search[:start_date_after]) if search[:end_date_before]

        paginate per_page:(params[:limit] || 3000), page:(params[:page] || 1)
      end

      @results = @search.results
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
end
