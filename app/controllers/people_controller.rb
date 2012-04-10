class PeopleController < ApplicationController
  respond_to :json

  def index
    solr = Person.search(:include => [:agencies]) do
      fulltext search_params["query"]
      paginate per_page:(params[:limit] || 3000), page:(params[:page] || 1)
    end
    @people = solr.results
    
    respond_with({ :people => @people, :total => solr.total })
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
