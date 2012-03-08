class PeopleController < ApplicationController
  respond_to :json

  def index
    if search["query"].nil? or search["query"].empty?
      @people = Person.all
    else
      solr = Person.search do
        fulltext search["query"]
      end
      @people = solr.results
    end
    
    respond_with({ :people => @people })
  end
  
  protected
  
  def search
    params.slice(:query)
  end
end
