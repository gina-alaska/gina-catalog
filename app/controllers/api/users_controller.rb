class Api::UsersController < ApplicationController
  def index
    @users = User.search(
      search_params,
      fields: [
        { 'name^2' => :word_start },
        { email: :word_start }
      ]
    )

    respond_to do |format|
      format.json
    end
  end

  protected

  def search_params
    params[:query].present? ? params[:query] : '*'
  end
end
