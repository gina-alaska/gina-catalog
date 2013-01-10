class CatalogsController < ApplicationController
  # caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  # caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }
  #caches_action :search

  include CatalogConcerns::Search
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
    @search_params['order_by'] ||= 'title_sort-ascending'
    @search = solr_search(@search_params, params[:page], params[:limit])
    
    if @search.respond_to? :results
      @results = @search.results
      @total = @search.total
    else
      @results = @search
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
end
