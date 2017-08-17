# part of gLynx

# controller of adiwg api endpoint

class Api::AdiwgController < ApplicationController
  # show action, gets metadata in ADIwg json format
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.json
    end
  end
end
