class SdsAdmin::AssetsController < SdsAdminController
  def index
    @search = Asset.search do 
      adjust_solr_params do |params|
        # Force solar to do an 'OR'ish search, at least 1 "optional" word is required in each  
        # ocean marine sea    ~> ocean OR marine OR sea
        # ocean marine +sea   ~> (ocean AND sea) OR (marine AND sea)
        # ocean +marine +sea  ~> ocean AND marine AND sea
        params[:mm] = "1"
        params[:ps] = 1
        params[:pf] = [:title, :description]
      end
      
      fulltext search_query
      with :owner_id, current_user.id unless current_user.is_an_admin?
      paginate per_page:(params[:limit] || 20), page:(params[:page] || 1)
    end
    session[:last_search_query] = params[:q] if params.include? :q
    @assets = @search.results
  end
  
  def edit
    @asset = fetch_asset
  end
  
  def update
    @asset = fetch_asset
    
    respond_to do |format|
      if @asset.update_attributes(asset_params)
        format.html do
          flash[:success] = "Successfully update asset information"
          redirect_to edit_sds_admin_asset_path(@asset)
        end
      else
        format.html do
          flash[:error] = "Error while updating asset information"
          render 'edit'
        end
      end
    end
  end
  
  def add_download_url
    @asset = fetch_asset
    @asset.download_urls.build
    
    respond_to do |format|
      format.html {
        render 'edit'
      }
    end
  end
  
  protected
  
  def search_query
    params[:q] || session[:last_search_query]
  end
  helper_method :search_query
  
  def asset_params
    params[:asset].slice(:use_agreement_id, :request_contact_info, :require_contact_info, :download_urls_attributes)
  end
  
  def fetch_asset
    Asset.find(params[:id])
  end
end
