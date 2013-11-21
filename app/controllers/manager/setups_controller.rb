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
    @setup = Setup.new(setup_params)
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
    if current_setup.update_attributes(setup_params)
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
  
  protected
  
  def setup_params
    @setup_params = params['setup'].dup
    if @setup_params.include? 'favicon_attributes' and @setup_params['favicon_attributes']['image'].blank? and !@setup_params['favicon_attributes']['_destroy'].to_i
      
      @setup_params.delete('favicon_attributes') 
    end
    
    @setup_params
  end
end
