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

    if(params[:filter].nil? or params[:filter].empty? )
      @results = Catalog.not_archived.published
      @results = @results.includes(:locations, :source_agency, :people, :agencies, :tags, :geokeywords)
      @results = @results.where(:id => params[:ids]) unless params[:ids].nil?
      @results = @results.limit(params[:limit] || 3000).order('title ASC')
    else
      filters = JSON.parse( params[:filter] )
      filters = Hash[filters.map{|item| [item["property"],item["value"]]}].symbolize_keys!
      
      @search = Catalog.search( :include => [:tags] ) do
        #data_accessor_for(Catalog).include=[:tags]
        fulltext filters[:fulltext]
        with :status, filters[:status] if filters[:status]
        with :archived_at, nil unless filters[:archived]
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
