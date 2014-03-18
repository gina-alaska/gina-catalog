class Admin::TagsController < AdminController
  def index
    @page = page = params[:page] || 1
    @limit = limit = params["limit"].nil? ? 30 : params["limit"]
    @sortdir = sortdir = params[:sort_direction] || "asc"
    @search = search_params

    @solr_search = Tag.search do
      fulltext search_params[:q] if search_params[:q]

      with(:record_count, 0) if search_params[:unused].present?
      order_by "text", sortdir.to_sym
      paginate per_page:(limit), page:(page)
    end

    @total = @solr_search.total
    @tags = @solr_search.results
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(params[:tag])
    
    if @tag.save
      respond_to do |format|
        flash[:success] = "Tag #{@tag.text} was successfully created."
        format.html { redirect_to admin_tags_path }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    if @tag.update_attributes(params[:tag])
      respond_to do |format|
        flash[:success] = "Tag #{@tag.text} was successfully updated."
        format.html { redirect_to admin_tags_path }
        format.json { head :nocontent }
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    tag_text = @tag.text
    @tag.destroy

    respond_to do |format|
      flash[:success] = "Tag #{tag_text} was successfully deleted."
      format.html { redirect_to admin_tags_path }
      format.json { head :no_content }
    end
  end

  protected

  def search_params
    params[:search] || {}
  end
end
