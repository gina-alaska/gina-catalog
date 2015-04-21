class Api::CollectionsController < ApplicationController
  def index
    @collections = current_portal.collections.order(:name)

    if params[:q].present?
      @collections = @collections.where('name ilike ?', "%#{params[:q]}%")
    end

    respond_to do |format|
      format.json
    end
  end
end
