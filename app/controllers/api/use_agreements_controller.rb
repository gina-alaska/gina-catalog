class Api::UseAgreementsController < ApplicationController
  def index
    @use_agreements = current_portal.use_agreements.all.order(:title)
    if params[:q].present?
      @use_agreements = @use_agreements.where('title ilike ?', "%#{params[:q]}%")
    end

    respond_to do |format|
      format.json
    end
  end
end
