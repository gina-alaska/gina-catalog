class PeopleController < ApplicationController
  respond_to :json

  def index
    solr = Person.search(:include => [:agencies, :phone_numbers]) do
      # Handle the sorting from the standard extjs data stores
      if params[:sort]
        s = JSON.parse(params[:sort]).first 
        field, direction = s["property"], s["direction"].downcase.to_sym
        order_by(field, direction) if field and direction      
      end         
      
      fulltext search_params["query"]
      paginate per_page:(params[:limit] || 3000), page:(params[:page] || 1)
    end
    @people = solr.results
    @total = solr.total
    
    respond_with({ :people => @people, :total => @total })
  end
  
  def show
    @person = Person.where(:id => params[:id]).first

    respond_with @person
  end

  def update
    @person = Person.where(:id => params[:id]).first

    if @person.update_attributes(person)    
      respond_to do |format|
        format.json { 
          render :json => {
            :success => true,
            :person => @person
          }
        }
      end
    else
      respond_to do |format|
        format.json { 
          render :json => {
            :success => false,
            :errors => @person.errors.full_messages
          }
        }
      end      
    end
  end

  def create
    @person = Person.new( person )

    if @person.save
      respond_to do |format|
        format.json {
          render :json => {
            :success => true,
            :person => @person
          }
        }
      end
    else
      respond_to do |format|
        format.json {
          render :json => {
            :success => false,
            :errors => @person.errors.full_messages
          }
        }
      end
    end
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

  def person
    params.slice(:first_name, :last_name, :email, :agency_ids, :url,
                 :work_phone, :alt_phone, :mobile_phone, :salutation, :suffix)
  end
end
