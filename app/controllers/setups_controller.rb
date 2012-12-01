class SetupsController < ApplicationController
  before_filter :fetch_setup, except: [:new,:create]
  
  def show
    if @setup.nil? 
      redirect_to new_setup_path
      return
    end
    
    respond_to do |format|
      format.html
      format.js
      format.css {
        raw  = render_to_string :template => 'setups/show.css.scss.erb'
        # erb  = ERB.new(raw).result(binding)
        opts = Compass.configuration.to_sass_engine_options.merge(
          :syntax => :scss,
          :custom => {:resolver => ::Sass::Rails::Resolver.new(CompassRails.context)},
        )
        render :text => Sass::Engine.new(raw, opts).render
      }
    end
  end
  
  def new
    @setup = Setup.new
  end
  
  def create
    @setup = Setup.new(params[:setup])
    @setup.url = request.host
    
    if @setup.save
      respond_to do |format|
        format.html {
          flash[:success] = 'First time setup completed!'
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
  
  def edit
  end
  
  def update
    if @setup.update_attributes(params[:setup])
      respond_to do |format|
        format.html {
          flash[:success] = 'Settings updated'
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
  
  def add_carousel_image
    @image = @setup.images.find(params[:image_id])
    
    if @image and !@setup.carousel_images.exists?(@image) and @setup.carousel_images << @image
      respond_to do |format|
        format.html {
          flash[:success] = "Added carousel image"
          redirect_to images_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Unable to add carousel image"
          redirect_to images_path
        }
      end
    end
  end
  
  def remove_carousel_image
    if @setup.carousel_images.delete(Image.find(params[:image_id]))
      respond_to do |format|
        format.html {
          flash[:success] = "Removed carousel image"
          redirect_to settings_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Unable to remove carousel image"
          redirect_to settings_path
        }
      end
    end
  end
end
