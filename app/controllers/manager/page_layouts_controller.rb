class Manager::PageLayoutsController < ManagerController
  # GET /setups/page_layouts/1
  # GET /setups/page_layouts/1.json
  def show
    @page_layout = @setup.layouts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page_layout }
    end
  end

  # GET /setups/page_layouts/new
  # GET /setups/page_layouts/new.json
  def new
    @page_layout = @setup.layouts.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page_layout }
    end
  end

  # GET /setups/page_layouts/1/edit
  def edit
    @page_layout = @setup.layouts.find(params[:id])
  end

  # POST /setups/page_layouts
  # POST /setups/page_layouts.json
  def create
    @page_layout = @setup.layouts.build(params[:page_layout])
    @setup.page_layouts << @page_layout

    respond_to do |format|
      if @page_layout.save
        format.html { redirect_to manager_path, notice: 'Page layout was successfully created.' }
        format.json { render json: @page_layout, status: :created, location: @page_layout }
      else
        format.html { render action: "new" }
        format.json { render json: @page_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /setups/page_layouts/1
  # PUT /setups/page_layouts/1.json
  def update
    @page_layout = @setup.layouts.find(params[:id])

    respond_to do |format|
      if @page_layout.update_attributes(params[:page_layout])
        format.html { redirect_to manager_path, notice: 'Page layout was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /setups/page_layouts/1
  # DELETE /setups/page_layouts/1.json
  def destroy
    @page_layout = @setup.page_layouts.find(params[:id])
    @page_layout.destroy

    respond_to do |format|
      format.html { redirect_to manager_path }
      format.json { head :no_content }
    end
  end
end
