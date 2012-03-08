class AgenciesController < ApplicationController
  respond_to :json

  def index
    if params[:query].nil? or params[:query].empty?
      @agencies = Agency.active
      @total = @agencies.count
    else
      search = Agency.search do
        adjust_solr_params do |params|
          params[:mm] = "1<1"
        end
        
        fulltext params[:query]
      end
      
      @agencies = search.results
      @total = search.total
    end

    respond_with({ :agencies => @agencies, :total => @total })
  end
end
