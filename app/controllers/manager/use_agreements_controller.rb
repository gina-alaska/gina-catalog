class Manager::UseAgreementsController < ManagerController
  before_filter :authenticate_access_catalog!

  SUBMENU = '/layouts/manager/catalog_menu'
  PAGETITLE = 'Use Agreements'

  def index
    @agreements = UseAgreement.all

    respond_to do |format|
      format.html
      format.json { render json: @agreements }
    end
  end

  def new
    @agreement = UseAgreement.new

    respond_to do |format|
      format.html
      format.json { render json: @agreement }
    end
  end

  def create
    @agreement = current_setup.use_agreements.build(params[:use_agreement])

    if @agreement.save
      respond_to do |format|
        flash[:success] = "Use agreement #{@agreement.title} was successfully created."
        format.html { redirect_to manager_use_agreements_path }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @agreement = UseAgreement.find(params[:id])
  end

  def update
    @agreement = UseAgreement.find(params[:id])

    if @agreement.update_attributes(params[:use_agreement])
      respond_to do |format|
        flash[:success] = "Use agreement #{@agreement.title} was successfully updated."
        format.html { redirect_to manager_use_agreements_path }
        format.json { head :nocontent }
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render json: @agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @agreement = UseAgreement.find(params[:id])
    @agreement.destroy if @agreement.catalogs.count == 0

    respond_to do |format|
      if @agreement.catalogs.count == 0
        flash[:success] = "Use agreement #{@agreement.title} was successfully deleted."
      else
        flash[:error] = "Use agreement #{@agreement.title} is associated and was not deleted!"
      end
      format.html { redirect_to manager_use_agreements_path }
      format.json { head :no_content }
      format.js
    end
  end
end
