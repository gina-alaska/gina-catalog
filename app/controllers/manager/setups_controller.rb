class Manager::SetupsController < ManagerController
  before_filter :fetch_setup, except: [:new,:create]
  
  PAGETITLE = 'Dashboard'
  SUBMENU = '/layouts/manager/settings_menu'
  
  def show
    page_title = "Portal Settings"
    @edit_button = true

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
    @setup.build_favicon
  end
  
  def create
    @setup = Setup.new(params[:setup])
    @setup.url = request.host
    
    if @setup.save
      respond_to do |format|
        format.html {
          flash[:success] = 'First time setup completed!'
          redirect_to manager_setup_path
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
    @setup = current_setup
    @setup.build_favicon if @setup.favicon.nil?
  end
  
  def update
    if params["setup"]["favicon_attributes"]["image"] == ""
      params["setup"]["favicon_attributes"]["_destroy"] = true 
    end
    
    if current_setup.update_attributes(params[:setup])
      respond_to do |format|
        format.html {
          flash[:success] = 'Settings updated'
          redirect_to manager_setup_path
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
end
