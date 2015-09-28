class PagesController < ApplicationController
  before_action :fetch_page
  before_action :redirect_to_default_url, only: [:index]
  before_action :redirect_to_page_not_found, only: [:show]
  before_action :redirect_to_root_if_home, only: [:show]

  def index
  end

  def show
    redirect_to @page.redirect_url if @page.redirect_url?
    render status: :not_found if params[:slug] == 'page_not_found'
  end

  protected

  def redirect_to_page_not_found
    redirect_to page_not_found_path if @page.nil?
  end

  def redirect_to_root_if_home
    redirect_to root_url if params[:slug] == 'home'
  end

  def redirect_to_default_url
    return if Rails.env.development?
    redirect_to "//#{current_portal.default_url.url}" if request.host != current_portal.default_url.url
  end

  def fetch_page
    slug = params[:slug].try(:split, '/') || 'home'
    @page = current_portal.pages.find_by_path(slug)
  end
end
