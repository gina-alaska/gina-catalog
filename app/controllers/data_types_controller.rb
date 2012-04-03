class DataTypesController < ApplicationController
  respond_to :json

  def index
    @data_types = DataType.all    
    respond_with({ :data_types => @data_types })
  end
end
