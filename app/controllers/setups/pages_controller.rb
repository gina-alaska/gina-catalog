class Setups::PagesController < ApplicationController
  def new
    @layouts = ['show']
    @page = @setup.pages.build
  end
  
  def edit
    @layouts = ['home', 'show']
    @page = @setup.pages.where(slug: params[:id]).first
  end
  
  def create
    @page = @setup.pages.build(params[:page])
    @setup.pages << @page
    
    if @page.save
      respond_to do |format|
        format.html {
          flash[:success] = "#{@page.title} page created"
          redirect_to settings_path
        }
      end
    else
      respond_to do |format|
        format.html {
          render action: 'new'
        }
      end      
    end
  end
  
  def update
    @page = @setup.pages.where(slug: params[:id]).first
    
    if @page.update_attributes(params[:page])
      respond_to do |format|
        format.html {
          flash[:success] = "#{@page.title} page updated"
          redirect_to settings_path
        }
      end
    else
      respond_to do |format|
        format.html {
          render action: 'edit'
        }
      end      
    end
  end
  
  def destroy
    @page = @setup.pages.where(slug: params[:id]).first
    
    if @page.destroy
      respond_to do |format|
        format.html {
          flash[:success] = "#{@page.title} page deleted"
          redirect_to settings_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:success] = "Unable to delete #{@page.title}"
          redirect_to settings_path
        }
      end
    end
  end
end
