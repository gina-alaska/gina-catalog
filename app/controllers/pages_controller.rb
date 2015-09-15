class PagesController < ApplicationController
  before_filter :fetch_page
  
  def index
  end

  def show
  end

  protected

  def fetch_page
    slug = params[:slug] || 'home'
    @page = current_portal.pages.friendly.find(slug)
  end
end
