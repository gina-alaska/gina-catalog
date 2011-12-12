class VideosController < ApplicationController
  respond_to :html

  def show
    @video = Video.find_by_name(params[:id])
    # if(!@video) 
    #   @video = Video.create(
    #     name: 'quickstart2x', filename: 'catalog2x_controller.swf', 
    #     path: '/video/catalog2x', title: 'Quick Start'
    #   )  
    # end
    
    if !@video.nil? and @video.exists?
      respond_with(@video)
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
end
