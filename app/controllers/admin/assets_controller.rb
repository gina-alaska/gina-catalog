class Admin::AssetsController < AdminController  
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
  
  protected
  
  def search_query
    params[:q] || session[:last_search_query]
  end
  helper_method :search_query
  
  def asset_params
    params[:asset].slice(:use_agreement_id, :request_contact_info, :require_contact_info)
  end
  
  def fetch_asset
    Asset.find(params[:id])
  end
end
