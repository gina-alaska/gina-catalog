class SessionsController < ApplicationController
  protect_from_forgery :except => [:create, :failure]
  
  def create
    if @auth = Service.find_from_hash(auth_hash) and @auth.valid?
      @auth.user.update_from_hash!(auth_hash)
    else
      # delete old invalid auths
      @auth.destroy unless @auth.nil?
      
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Service.create_from_hash(auth_hash, current_user)      
      added_provider = true if @auth.valid?
    end
    
    # Log the authorizing user in.
    if @auth.valid?
      if added_provider
        flash[:success] = "Successfully added new identify provider"
      else
        flash[:success] = 'Logged in succesfully'    
      end
      
      self.current_user = @auth.user
      Rails.logger.info 'User logged in successfully'
    else
      flash[:error] = "Unable to create your account, if you have logged in previously using a different method please login using that method instead."
      flash[:error] += '<br />' + @auth.user.errors.full_messages.join('<br />') unless @auth.user.nil?
      Rails.logger.info 'User failed to login'
    end
    
    redirect_back_or_default('/')
  end
  
  def destroy
    signout
    flash[:success] = 'You have been logged out'    
    redirect_back_or_default('/')
  end
  
  def failure
    flash[:error] = params[:message] # if using sinatra-flash or rack-flash
    redirect_to '/'
  end
  
  def test
    render text: session.inspect
  end

  protected

  def signout
    session[:user_id] = nil
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
end