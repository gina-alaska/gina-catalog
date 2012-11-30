class CatalogsController < ApplicationController
  # caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  # caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }
  #caches_action :search
  before_filter :authenticate_manager!, :only => [:create, :update, :publish]

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
    @catalog = Catalog.where(:id => params[:id]).first
    
    respond_to do |format|
      format.json {
        render json: { use_agreement: @catalog.use_agreement, request_contact_info: @catalog.request_contact_info? }
      }
    end
  end

  def search
    @search_params = params[:search] || {}
    @search = solr_search(@search_params)
    
    if @search 
      @results = @search.results
      @total = @search.total
    else
      @results = []
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

  def publish
    @item = Catalog.where(:id => params[:id]).first

    if (@item.published_at.nil? || @item.published_at > Time.now.utc) 
      @item.published_at = Time.now.utc
    else
      @item.published_at = nil
    end

    if(@item.save)
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

  protected
  
  def catalog
    v = params.slice(
          :title, :description, :agengy_ids, :tags, :source_agency_id, :funding_agency_id, :status,
          :geokeyword_ids, :links_attributes, :locations_attributes, :data_type_ids, :primary_contact_id,
          :agency_ids, :contact_ids, :iso_topic_ids, :start_date, :end_date, :long_term_monitoring, :person_ids
    )    
    v["tags"] = v["tags"].split(/,\s+/)
    
    v
  end

  def solr_search(search)    
    return false if search.nil? or search.keys.empty?
    
    table_includes = {
      :tags => [], :locations => [], :agencies => [], :source_agency => [], :funding_agency => [], :links => [], 
      :primary_contact => [:phone_numbers], :people => [:phone_numbers], :data_source => [], :geokeywords => [], 
      :repo => []
    }
  
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

    results = Sunspot.search(Project, Asset) do
      # adjust_solr_params do |params|
      #   # Force solar to do an 'OR'ish search, at least 1 "optional" word is required in each  
      #   # ocean marine sea    ~> ocean OR marine OR sea
      #   # ocean marine +sea   ~> (ocean AND sea) OR (marine AND sea)
      #   # ocean +marine +sea  ~> ocean AND marine AND sea
      #   params[:mm] = "1"
      #   params[:ps] = 1
      #   params[:pf] = [:title, :description]
      # end

      data_accessor_for(Project).include=table_includes
      data_accessor_for(Asset).include=table_includes
      fulltext search[:q]
      with :id, catalog_ids unless catalog_ids.nil? or catalog_ids.empty?
      with :status, search[:status] if search[:status].present?
      with :long_term_monitoring, ((search[:long_term_monitoring].to_i > 0) ? true : false) if search.include? :long_term_monitoring
      with :archived_at_year, nil unless search[:archived]
      with :type, search[:type] if search[:type].present?
      with :agency_ids, search[:agency_ids] if search[:agency_ids].present?
      with :source_agency_id, search[:source_agency_id] if search[:source_agency_id].present?
      with :iso_topic_ids, search[:iso_topic_ids] if search[:iso_topic_ids].present?
      with :person_ids, search[:contact_ids] if search[:contact_ids].present?
      with :geokeywords_name, search[:region] if search[:region].present?
      with :data_types, search[:data_types] if search[:data_types].present?
  
      with(:published_at).less_than(Time.zone.now) unless current_user and current_user.is_an_admin?
      
      with(:start_date_year).greater_than(search[:start_date_after]) if search[:start_date_after].present?

      with(:start_date_year).less_than(search[:start_date_before]) if search[:start_date_before].present?

      with(:end_date_year).greater_than(search[:end_date_after]) if search[:end_date_after].present?
      
      with(:end_date_year).less_than(search[:end_date_before]) if search[:end_date_before].present?

      paginate per_page:(params[:limit] || 10000), page:(params[:page] || 1)
      
      order_by(field, direction) if field and direction
    end
   
    results
  end
end
