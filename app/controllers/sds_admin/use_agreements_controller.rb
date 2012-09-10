class SdsAdmin::UseAgreementsController < SdsAdminController
  def index
    @use_agreements = UseAgreement.all
  end
  
  def edit
    @use_agreement = fetch_use_agreement
  end
  
  def update
    @use_agreement = fetch_use_agreement
    
    respond_to do |format|
      if @use_agreement.update_attributes(use_agreement_params)
        format.html do
          flash[:success] = "Successfully updated #{@use_agreement.title}"
          redirect_to sds_admin_use_agreements_path
        end
      else
        format.html do
          flash[:error] = "Error while updating use agreement"
          render 'edit'
        end
      end
    end
  end
  
  def new
    @use_agreement = UseAgreement.new
  end
  
  def create
    @use_agreement = UseAgreement.new(use_agreement_params)
    
    respond_to do |format|
      if @use_agreement.save
        format.html do
          flash[:success] = "Successfully created #{@use_agreement.title}"
          redirect_to sds_admin_use_agreements_path
        end
      else
        format.html do
          flash[:error] = "Error while creating use agreement"
          render 'new'
        end
      end
    end    
  end
  
  protected
  
  def use_agreement_params
    params[:use_agreement].slice(:title, :content)
  end
  
  def fetch_use_agreement
    UseAgreement.find(params[:id])
  end
end
