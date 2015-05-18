class Api::DataTypesController < ApplicationController
  def index
    @data_types = DataType.all.order(:name)
    if params[:q].present?
      @data_types = @data_types.where('name ilike ?', "%#{params[:q]}%")
    end

    respond_to do |format|
      format.json
    end
  end
end
