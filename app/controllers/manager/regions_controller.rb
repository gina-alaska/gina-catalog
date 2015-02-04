class Manager::RegionsController < ApplicationController
  def search
    @regions = Region.all.order(:name)
    if params[:q].present?
      @regions = @regions.where('name ilike ?', "%#{params[:q]}%")
    end
  end
end
