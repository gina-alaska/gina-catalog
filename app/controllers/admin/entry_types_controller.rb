class Admin::EntryTypesController < AdminController

  load_and_authorize_resource

  def index
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @entry_type.save
        flash[:success] = "Catalog type #{@entry_type.name} was created."
        format.html { redirect_to admin_entry_types_path }
      else
        format.html { render action: "new" }
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
        format.html { render action: "edit" }
        format.json { render json: @entry_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry_type.destroy

    respond_to do |format|
      flash[:success] = "Catalog type #{@entry_type.name} was deleted."
      format.html { redirect_to admin_entry_types_path }
      format.json { head :no_content }
    end
  end

  protected
  
  def entry_type_params
    params.require(:entry_type).permit(:name, :description, :color)
  end
end
