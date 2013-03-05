class PagesController < ApplicationController
  before_filter :fetch_page, except: [:index,:not_found]

  # GET /pages/1
  # GET /pages/1.json
  def show
    respond_to do |format|
      format.html {
        if @page.redirect?
          redirect_to @page.redirect
        end
      }
      format.json { render json: @page }
    end
  end
  
  def not_found
    
  end
  
  protected
  
  def fetch_page
    @page = current_setup.pages.where(slug: params[:slug]).first
    if @page.nil?
      redirect_to page_path('404-not-found')
    end
  end
end
