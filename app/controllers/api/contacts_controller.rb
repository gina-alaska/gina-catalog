class Api::ContactsController < ApplicationController
  def index
    @contacts = Contact.search(search_params)

    respond_to do |format|
      format.json
    end
  end

  protected

  def search_params
    params[:query].present? ? params[:query] : '*'
  end
end
