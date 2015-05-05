class Api::TagsController < ApplicationController
  def index
    @tags = Entry.all_tags.order(:name)
    if params[:q].present?
      @tags = @tags.where('name ilike ?', "%#{params[:q]}%")
    end

    respond_to do |format|
      format.json
    end
  end
end
