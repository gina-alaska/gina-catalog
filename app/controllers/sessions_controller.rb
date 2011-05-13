# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :admin_required, :only => [:new, :create]

  def index
    respond_to do |format|
      format.json { render :json => { :success => logged_in? } }
    end
  end

  # render new.rhtml
  def new
    open_id_authentication('http://id.gina.alaska.edu')
  end

  def create
    logout_keeping_session!
    if using_open_id?
      open_id_authentication
    elsif using_gina_id?
      open_id_authentication("http://id.gina.alaska.edu/#{params[:gina_username]}")
    else
      failed_login "Sorry, invalid credentials given"
    end
  end

  def using_gina_id?
    params[:gina_username]
  end

  def open_id_authentication(openid_url = open_id_identifier)
    # Pass optional :required and :optional keys to specify what sreg fields you want.
    # Be sure to yield registration, a third argument in the #authenticate_with_open_id block.
    authenticate_with_open_id(openid_url,
            :required => [ :email ], :optional => :fullname) do |result, identity_url, registration|
      case result.status
      when :missing
        failed_login "Sorry, the OpenID server couldn't be found"
      when :invalid
        failed_login "Sorry, but this does not appear to be a valid OpenID"
      when :canceled
        failed_login "OpenID verification was canceled"
      when :failed
        failed_login "Sorry, the OpenID verification failed"
      when :successful
        if user = User.find_by_identity_url(identity_url)
          assign_registration_attributes!(user, registration)

          if user.save
            successful_login(user)
          else
            failed_login "Your OpenID profile registration failed: " +
              user.errors.full_messages.to_sentence
          end
        else
          user = User.new
          user.identity_url = identity_url
          assign_registration_attributes!(user, registration)

          if user.save
            successful_login(user)
          else
            failed_login "Error while creating a new user account: <br />" +
              user.errors.full_messages.to_sentence
          end
        end
      end
    end
  end

  # registration is a hash containing the valid sreg keys given above
  # use this to map them to fields of your user model
  def assign_registration_attributes!(user, registration)
    model_to_registration_mapping.each do |model_attribute, registration_attribute|
      unless registration[registration_attribute].blank?
        user.send("#{model_attribute}=", registration[registration_attribute])
      end
    end
  end

  def model_to_registration_mapping
    { :email => 'email', :fullname => 'fullname' }
  end

  def destroy
    logout_killing_session!
    flash.notice = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

private
  def successful_login(user, skip_redirect=false)
    self.current_user = user
    flash.notice = "#{user.fullname} has been logged in<br />If this is not correct, please click <a href='http://id.gina.alaska.edu/logout'>here</a>"
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default('/') unless skip_redirect
  end

  def failed_login(message)
    flash[:error] = message
    redirect_to('/')
  end
end
