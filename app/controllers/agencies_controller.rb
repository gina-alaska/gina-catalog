class AgenciesController < ApplicationController
  respond_to :json

  def index
    @agencies = Agency.active

    respond_with({ :agencies => @agencies })
  end
end
