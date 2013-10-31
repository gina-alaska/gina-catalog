class AuthenticationsController < ApplicationController
  before_filter :fetch_setup, :only => []
	before_filter :authenticate_user!, :except => [:create, :signin, :signout, :signup, :newaccount, :failure]

	protect_from_forgery :except => :create		# see https://github.com/intridea/omniauth/issues/203

 # POST from signup view
	def newaccount
		if params[:commit] == "Cancel"
			session[:authhash] = nil
			session.delete :authhash
			redirect_to root_url
		else	# create account
			@newuser = User.where('email = ?', session[:authhash][:email]).first
			@newuser ||= User.new

			# Check to see if this is a new user or one that needs to be upgraded to the new auth system
      # if @newuser.new_record? || (@newuser.services.empty? && @newuser.identity_url == session[:authhash][:uid])
      #   @newuser.fullname = session[:authhash][:name]
      #   @newuser.email = session[:authhash][:email]
      # else
      #   # User already exists and has been upgraded
      #   # someone is probably trying to spoof their account from another auth system
      #   @newuser = nil
      #         flash[:error] = "There was an error while trying to upgrade your account, please email info@gina.alaska.edu to get this problem resolved."
      #         redirect_to root_url
      #         return
      # end
			@newuser.fullname = session[:authhash][:name]
			@newuser.email = session[:authhash][:email]
			@newuser.services.build( :provider => session[:authhash][:provider], :uid => session[:authhash][:uid], 
																:uname => session[:authhash][:name], :uemail => session[:authhash][:email])

			if @newuser && @newuser.save
				# signin existing user
	      # in the session his user id and the service id used for signing in is stored
	      session[:user_id] = @newuser.id
	      session[:service_id] = @newuser.services.first.id

	      flash[:notice] = 'Your account has been created and you have signed in!'
	      redirect_back_or_default root_url
	    else
	    	flash[:error] = 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
	      redirect_to root_url
	    end
	  end
	end

	# callback: success
	# This handles signing in and adding an authentication service to existing accounts itself
	# It renders a separate view if there is a new user to create
	def create
		# get the service parameter from the Rails router
		params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

		# get the full hash from omniauth
		omniauth = request.env['omniauth.auth']

		# continue only if hash and parameter exist
		if omniauth and params[:service]

			# map the returned hashes to our variables first - the hashes differs for every service
    
    	# create a new hash
    	@authhash = Hash.new
    	if service_route == 'facebook'
      	omniauth['extra']['raw_info']['email'] ? @authhash[:email] =  omniauth['extra']['raw_info']['email'] : @authhash[:email] = ''
      	omniauth['extra']['raw_info']['name'] ? @authhash[:name] =  omniauth['extra']['raw_info']['name'] : @authhash[:name] = ''
      	omniauth['extra']['raw_info']['id'] ?  @authhash[:uid] =  omniauth['extra']['raw_info']['id'].to_s : @authhash[:uid] = ''
      	omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
    	elsif service_route == 'github'
      	omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
      	omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
	      omniauth['extra']['user_hash']['id'] ? @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
	      omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''  
	    elsif ['google', 'yahoo', 'twitter', 'myopenid', 'open_id', 'gina'].index(service_route) != nil
	      omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
	      omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
	      omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
	      omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''     
			else
				# debug to output the hash that has been returned when adding new services
				render :text => omniauth.to_yaml
				return
			end

			if @authhash[:uid] != '' and @authhash[:provider] != ''

				auth = Service.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

				# if the user is currently signed in, he/she might want to add another account to signin
				if user_signed_in?
					if auth
						flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with the site.'
						redirect_back_or_default '/'
					else
						current_user.services.create!(:provider => @authhash[:provider], :uid => @authhash[:uid], :uname => @authhash[:uname], :uemail => @authhash[:uemail])
						flash[:notice] = 'Your ' + @authhash[:provider].capitalize +  ' account has been added for signing in at this site.'
						redirect_back_or_default '/'
					end
				else
					if auth
						# signin existing user
          	# in the session his user id and the service id used for signing in is stored
          	session[:user_id] = auth.user.id
          	session[:service_id] = auth.id

          	flash[:notice] = 'Signed up successfully via ' + @authhash[:provider].capitalize + '.'
          	redirect_back_or_default root_url
          else
          	# this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
          	session[:authhash] = @authhash
          	render signup_authentications_path
          end
        end
      else
	      flash[:error] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
        redirect_to signin_path
      end
    else
    	flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
    	redirect_to signin_path
  	end
  end


	# GET all authentication services assigned to the current user
  def index
	  @services = current_user.services.order('provider asc')
	end

	def destroy
	  # remove an authentication service linked to the current user
	  @service = current_user.services.find(params[:id])

	  if session[:service_id] == @service.id
	    flash[:error] = 'You are currently signed in with this account!'
	  else
	    @service.destroy
	  end

	  redirect_to authentications_path
	end

  # Sign out current user
	def signout 
	  if current_user
	    session[:user_id] = nil
	    session[:service_id] = nil
	    session.delete :user_id
	    session.delete :service_id
	    flash[:notice] = 'You have been signed out!'
	  end 
	  redirect_to root_url
	end

  # callback: failure
	def failure
	  flash[:error] = 'There was an error at the remote authentication service. You have not been signed in.'
	  redirect_to root_url
	end
end