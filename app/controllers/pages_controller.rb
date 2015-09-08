class PagesController < ApplicationController
  def index
  end

  def show
    @page = current_portal.pages.friendly.find(params[:slug])
  end
end
