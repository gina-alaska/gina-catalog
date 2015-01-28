class Manager::UseAgreementsController < ApplicationController
  load_and_authorize_resource

  def index
    @use_agreements = UseAgreement.all
  end

  #  def show
  #  end

  def new
    @use_agreement = UseAgreement.new
  end

  def edit
  end

  def create
    @use_agreement = UseAgreement.new(use_agreement_params)

    respond_to do |format|
      if @use_agreement.save
        flash[:success] = "Use agreement #{@use_agreement.title} was successfully created."
        format.html { redirect_to manager_use_agreements_path }
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
        format.html { redirect_to manager_use_agreements_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @use_agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @use_agreement.destroy
        flash[:success] = "use agreement #{@use_agreement.title} was successfully deleted."
        format.html { redirect_to manager_use_agreements_path }
        format.json { head :no_content }
      else
        flash[:error] = @use_agreement.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to manager_use_agreements_path }
      end
    end
  end

  protected

  def use_agreement_params
    params.require(:use_agreement).permit(:title, :body, :required, :archived)
  end
end
