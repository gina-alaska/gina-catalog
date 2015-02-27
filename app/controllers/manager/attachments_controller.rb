class Manager::AttachmentsController < ApplicationController
  load_and_authorize_resource find_by: :uuid

  def show
    respond_to do |format|
      format.js
    end
  end
end
