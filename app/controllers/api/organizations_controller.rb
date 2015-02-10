class Api::OrganizationsController < ApplicationController
  def index
    @organizations = Organization.search(search_params)

    respond_to do |format|
      format.json
    end
  end

  protected

  def search_params
    params[:query].present? ? params[:query] : '*'
  end
end
