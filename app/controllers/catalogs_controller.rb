class CatalogsController < ApplicationController
  # caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  # caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }
  #caches_action :search

  include CatalogConcerns::Search

  def show
    @item = Catalog.includes(:locations, :source_agency, :agencies, :data_source, :links, :tags, :geokeywords)
    @item = @item.includes({ :people => [ :addresses, :phone_numbers ] }).find_by_id(params[:id])

    respond_to do |format|
      format.html { 
        if request.xhr?
          render :layout => false 
        end
      }
      format.json { render :json => @item.as_json(:format => 'full') }
      format.tar_gz do
        send_file(@item.repo.archive_filenames[:tar_gz])
      end
      format.zip do
        send_file(@item.repo.archive_filenames[:zip])
      end
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

  def search
    @agencies = Agency.select([:name,:id]).collect{|a| [a.name, a.id]}.group_by{|a| a.first.first }
     #Agency.all #.group_by{|a| a.name[0]}
  
    @search_params = params[:search] || {}
    @limit = params[:limit] || 30
    @pagenum = params[:page] || 1

    advanced_opts = @search_params.reject { |k,v| v.blank? or ['q', 'catalog_collection_ids', 'order_by'].include?(k) }
    @is_advanced = advanced_opts.keys.size > 0
    
    if (@search_params['q'].nil? or @search_params['q'].blank?)
      @search_params[:order_by] = 'title_sort-ascending'
    else
      @search_params.delete(:order_by)
    end
    logger.info '=-=-=-=-=-=-=-=-=-'
    logger.info @search_params[:order_by]
    
    unless current_user and current_member.can_manage_cms?
      @search_params[:published_only] = true
    end
    
    @search = solr_search(@search_params, @pagenum, @limit)
    if @search.respond_to? :results
      @results = @search.results
      @total = @search.total
    else
      @results = Array.wrap(@search)
      @total = 0
    end
    
    
    respond_to do |format|
      format.json
      format.js
      format.html
      format.pdf do
        render :pdf => 'nssi_catalog_search.pdf', :layout => 'pdf.html'
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
        render :layout => false
      end
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
end
