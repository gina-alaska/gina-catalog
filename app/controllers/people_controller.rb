class PeopleController < ApplicationController
  respond_to :json

  def index
    @people = Person.all
    respond_with({ :people => @people })
  end
end
