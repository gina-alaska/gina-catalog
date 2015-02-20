class Api::ContactsController < ApplicationController
  def index
    @contacts = Contact.search(
      search_params,
      fields: [
        { 'name^2' => :word_start },
        { email: :word_start },
        { job_title: :word_start }
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
