class Catalog::UseAgreementsController < CatalogController
  load_and_authorize_resource

  def index
    @q = UseAgreement.ransack(params[:q])
    @q.sorts = 'title asc' if @q.sorts.empty?
    @use_agreements = @q.result(distinct: true).page(params[:page])
    @use_agreements = @use_agreements.used_by_portal(current_portal) unless params[:all].present?
    respond_to do |format|
      format.html
      format.json { render json: @use_agreements }
    end
  end

  def show; end

  def new; end

  def edit
    save_referrer_location
  end

  def create
    @use_agreement = UseAgreement.new(use_agreement_params)
    current_portal.use_agreements << @use_agreement

    respond_to do |format|
      if @use_agreement.save
        flash[:success] = "Use agreement #{@use_agreement.title} was successfully created."
        format.html { redirect_to catalog_use_agreements_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @use_agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @use_agreement.update_attributes(use_agreement_params)
        flash[:success] = "Use agreement #{@use_agreement.title} was successfully updated."
        format.html { redirect_to catalog_use_agreements_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @use_agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    save_referrer_location

    respond_to do |format|
      if @use_agreement.destroy
        flash[:success] = "Use agreement #{@use_agreement.title} was successfully deleted."
        format.html { redirect_to catalog_use_agreements_path }
        format.json { head :no_content }
      else
        flash[:error] = @use_agreement.errors.full_messages.join('<br />').html_safe
        format.html { redirect_back_or_default catalog_use_agreements_path }
      end
    end
  end

  def archive
    @use_agreement.archive!(params[:message], current_user)

    respond_to do |format|
      flash[:success] = "Use agreement #{@use_agreement.title} has been archived."
      format.html { redirect_to catalog_use_agreements_path }
      format.json { head :no_content }
    end
  end

  def unarchive
    @use_agreement.unarchive!

    respond_to do |format|
      flash[:success] = "Use agreement #{@use_agreement.title} has been restored."
      format.html { redirect_to catalog_use_agreements_path }
      format.json { head :no_content }
    end
  end

  protected

  def use_agreement_params
    params.require(:use_agreement).permit(:title, :body, :required, :archived)
  end
end
