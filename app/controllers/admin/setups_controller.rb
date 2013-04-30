class Admin::SetupsController < AdminController
  def index
    @setups = Setup.roots
  end

  def new
    @setup = Setup.new
    @setup.urls.build
    # @setup.urls << SiteUrl.new
  end

  def create
    @setup = Setup.new(params[:setup])

    if @setup.save!
      respond_to do |format|
        flash[:success] = "Setup #{@setup.title} was successfully created."
        format.html { redirect_to admin_setups_path }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @setup.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @setup = Setup.find(params[:id])
  end

  def update
    @setup = Setup.where(id: params[:id]).first

    if @setup.update_attributes(params[:setup])
      respond_to do |format|
        flash[:success] = "Setup #{@setup.title} was successfully updated."
        format.html { redirect_to admin_setups_path }
        format.json { head :nocontent }
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render json: @setup.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @setup = Setup.find(params[:id])
    @setup.destroy

    respond_to do |format|
      flash[:success] = "Setup #{@setup.title} was successfully deleted."
      format.html { redirect_to admin_setups_path }
      format.json { head :no_content }
    end
  end
end
