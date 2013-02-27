class Manager::ImagesController < ManagerController
  before_filter :fetch_page, :only => [:add, :remove]
  before_filter :fetch_image, :except => [:index, :new, :create]

  # GET /manager/images
  # GET /manager/images.json
  def index
    @images = @setup.images

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /manager/images/1
  # GET /manager/images/1.json
  def show
    @image = @setup.images.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /manager/images/new
  # GET /manager/images/new.json
  def new
    @image = @setup.images.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /manager/images/1/edit
  def edit
    @image = @setup.images.find(params[:id])
  end

  # POST /manager/images
  # POST /manager/images.json
  def create
    @image = Image.new(params[:image])
    @setup.images << @image
    
    unless params[:page][:id].empty?
      @page = current_setup.pages.find(params[:page][:id])
    end

    respond_to do |format|
      if @image.save
        format.html { 
          flash[:success] = 'Image was successfully created.'
          if @page.nil?
            redirect_to manager_images_path 
          else
            @page.images << @image
            redirect_to edit_manager_page_path(@page)
          end
        }
        format.json { render json: @image, status: :created, location: [:manager, @image] }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/images/1
  # PUT /manager/images/1.json
  def update
    @image = @setup.images.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { 
          flash[:success] = 'Image was successfully updated.'
          redirect_back_or_default manager_images_path 
        }
          
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/images/1
  # DELETE /manager/images/1.json
  def destroy
    @image = @setup.images.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to manager_images_path }
      format.json { head :no_content }
    end
  end 
  
  # POST /manager/page/:page_id/image/:id/add
  def add
    if @image and !@page.images.exists?(@image) and @page.images << @image
      respond_to do |format|
        format.html {
          flash[:success] = "Added image"
          redirect_to edit_manager_page_path(@page)
        }
        format.js
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Unable to add image"
          redirect_to edit_manager_page_path(@page)
        }
        format.js
      end
    end
  end
  
  # POST /manager/page/:page_id/image/:id/remove
  def remove
    if @image and @page.images.delete(@image)
      respond_to do |format|
        format.html {
          flash[:success] = "Added image"
          redirect_to edit_manager_page_path(@page)
        }
        format.js
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Unable to add image"
          redirect_to edit_manager_page_path(@page)
        }
        format.js
      end
    end
  end  

  protected
  
  def fetch_page
    @page = @setup.pages.find(params[:page_content_id])
  end
  
  def fetch_image
    @image = @setup.images.find(params[:id])
  end
end
