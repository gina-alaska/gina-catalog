class RegionsController < ApplicationController
  def index
    @regions = Region.all.order(:name)
    if params[:q].present?
      @regions = @regions.where('name ilike ?', "%#{params[:q]}%")
    end

    respond_to do |format|
      format.json
    end
  end
end
