class Manager::UseAgreementsController < ManagerController

  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'SDS'

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

    if @agreement.save!
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
    @agreement.destroy

    respond_to do |format|
      flash[:success] = "Use agreement #{@agreement.title} was successfully deleted."
      format.html { redirect_to manager_use_agreements_path }
      format.json { head :no_content }
      format.js
    end
  end
end
