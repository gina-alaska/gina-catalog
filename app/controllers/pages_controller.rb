class PagesController < ApplicationController
  before_filter :fetch_page
  before_filter :redirect_to_default_url, only: [:index]

  def index
  end

  def show
    redirect_to root_url if params[:slug] == 'home'
  end

  protected

  def redirect_to_default_url
    return if Rails.env.development?
    redirect_to "//#{current_portal.default_url.url}" if request.host != current_portal.default_url.url
  end

  def fetch_page
    slug = params[:slug].try(:split, '/') || 'home'
    @page = current_portal.pages.find_by_path(slug)
  end
end
