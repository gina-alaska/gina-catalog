class Manager::CollectionsController < ApplicationController
  load_and_authorize_resource

  def index
    @q = Collection.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @collections = @q.result(distinct: true)
    @collections = @collections.used_by_portal(current_portal) unless params[:all].present?

    respond_to do |format|
      format.html
      format.json { render json: @collections }
    end
  end

  #  def show
  #  end

  def new
    @collection = Collection.new
  end

  def edit
    save_referrer_location
  end

  def create
    @collection = Collection.new(collection_params)
    current_portal.collections << @collection

    respond_to do |format|
      if @collection.save
        flash[:success] = "Collection #{@collection.name} was successfully created."
        format.html { redirect_back_or_default manager_collections_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @collection.update_attributes(collection_params)
        flash[:success] = "Collection #{@collection.name} was successfully updated."
        format.html { redirect_back_or_default manager_collections_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    save_referrer_location
    @collection.destroy

    respond_to do |format|
      flash[:success] = "Collection #{@collection.name} was successfully deleted."
      format.html { redirect_back_or_default manager_collections_path }
      format.json { head :no_content }
    end
  end

  protected

  def collection_params
    params.require(:collection).permit(:name, :description, :hidden)
  end
end
