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
    @page = @page.global_page if @page.try(:global_page)

    if @page.nil?
      top_page = current_setup.pages.where(slug: params[:slug].split("/").first).first
      if top_page.try(:global_page)
        @page = top_page.global_page.descendants.where(slug: params[:slug]).first
      end
    end

    if @page.nil? or (@page.draft and (!user_signed_in? or !current_member.can_manage_cms?))
      redirect_to page_path('404-not-found')
    end
  end
end
