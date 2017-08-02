class PagesController < ApplicationController
  before_action :fetch_page
  before_action :redirect_to_default_url, only: [:index]
  before_action :redirect_to_page_not_found, only: [:show]
  before_action :follow_redirect_url
  before_action :redirect_to_root_if_home, only: [:show]

  def index; end

  def show
    render status: :not_found if params[:slug] == 'page_not_found'
  end

  protected

  def follow_redirect_url
    redirect_to @page.redirect_url if @page.redirect_url?
  end

  def redirect_to_page_not_found
    redirect_to page_not_found_path if @page.nil?
  end

  def redirect_to_root_if_home
    redirect_to root_url if params[:slug] == 'home'
  end

  def redirect_to_default_url
    redirect_to "//#{current_portal.default_url.url}" if current_portal.urls.find_active_url(request.host).nil?
  end

  def fetch_page
    slug = params[:slug].try(:split, '/') || 'home'
    pages = current_portal.pages
    pages = pages.active if cannot? :manage, Cms::Page
    @page = pages.find_by_path(slug)
  end
end
