class Admin::DataTypesController < AdminController
  load_and_authorize_resource

  def index; end

  def new; end

  def edit; end

  def create
    respond_to do |format|
      if @data_type.save
        flash[:success] = "Data type #{@data_type.name} was created."
        format.html { redirect_to admin_data_types_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @data_type.update_attributes(data_type_params)
        flash[:success] = "Data type #{@data_type.name} was updated."
        format.html { redirect_to admin_data_types_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @data_type.destroy
        flash[:success] = "Data type #{@data_type.name} was successfully deleted."
        format.html { redirect_to admin_data_types_path }
        format.json { head :no_content }
      else
        flash[:error] = @data_type.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to admin_data_types_path }
        #         format.json { head :no_content }
      end
    end
  end

  protected

  def data_type_params
    params.require(:data_type).permit(:name, :description)
  end
end
