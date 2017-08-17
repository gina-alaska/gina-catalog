class Admin::EntryTypesController < AdminController
  load_and_authorize_resource

  def index; end

  def new; end

  def edit; end

  def create
    respond_to do |format|
      if @entry_type.save
        flash[:success] = "Catalog type #{@entry_type.name} was created."
        format.html { redirect_to admin_entry_types_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @entry_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @entry_type.update_attributes(entry_type_params)
        flash[:success] = "Catalog type #{@entry_type.name} was updated."
        format.html { redirect_to admin_entry_types_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entry_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @entry_type.destroy
        flash[:success] = "Catalog type #{@entry_type.name} was successfully deleted."
        format.html { redirect_to admin_entry_types_path }
        format.json { head :no_content }
      else
        flash[:error] = @entry_type.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to admin_entry_types_path }
        #         format.json { head :no_content }
      end
    end
  end

  protected

  def entry_type_params
    params.require(:entry_type).permit(:name, :description, :color)
  end
end
