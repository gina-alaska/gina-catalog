class AgenciesController < ApplicationController
  respond_to :json

  def index
    logger.info '*************'
    logger.info search_params.inspect
    
    if search_params["query"].nil? or search_params["query"].empty?
      @agencies = Agency.active
      @total = @agencies.count
    else
      search = Agency.search do
        adjust_solr_params do |p|
          p[:mm] = "1<1"
        end
        
        fulltext search_params["query"]
      end
      
      @agencies = search.results
      @total = search.total
    end

    respond_with({ :agencies => @agencies, :total => @total })
  end
  
  protected
  
  def search_params
    search = { "query" => params[:query] } unless params[:query].nil?
    search ||= {}
    
    # Handle the filters from the standard extjs data stores
    if params[:filter]
      JSON.parse(params[:filter]).each do |f|
        search[f["property"]] = f["value"]
      end
    end
    
    search
  end
end
