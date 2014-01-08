require 'openid/store/memcache'
require 'openid/fetchers'
if ::File.exists? "/etc/ssl/certs/ca-bundle.crt"
  OpenID.fetcher.ca_file = "/etc/ssl/certs/ca-bundle.crt"  #This is where it lives on centos
end

Rails.application.config.middleware.use OmniAuth::Builder do
  # ALWAYS RESTART YOUR SERVER IF YOU MAKE CHANGES TO THESE SETTINGS!
   
  # you need a store for OpenID; (if you deploy on heroku you need Filesystem.new('./tmp') instead of Filesystem.new('/tmp'))
  require 'openid/store/filesystem'
   
  # providers with id/secret, you need to sign up for their services (see below) and enter the parameters here
  # provider :facebook, 'APP_ID', 'APP_SECRET'
  # provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  # provider :github, 'CLIENT ID', 'SECRET'
   
  # generic openid
  # provider :openid, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'
   
  # dedicated openid

  memcached_client = OpenID::Store::Memcache.new(
    Dalli::Client.new("flash.x.gina.alaska.edu",
      username: ENV['MEMCACHE_USERNAME'],
      password: ENV['MEMCACHE_PASSWORD'],
      namespace: 'glynx-authentication'
    )
  )
    
  provider :open_id, name: 'google', 
            identifier: 'https://www.google.com/accounts/o8/id',
            store: memcached_client
  
  provider :open_id, name: 'gina',
            identifier: 'https://id.gina.alaska.edu',
            store: memcached_client
            
  # provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :name => 'google_apps'
  # /auth/google_apps; you can bypass the prompt for the domain with /auth/google_apps?domain=somedomain.com
   
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'aol', :identifier => 'openid.aol.com'
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'myopenid', :identifier => 'myopenid.com'

  # Sign-up urls for Facebook, Twitter, and Github
  # https://developers.facebook.com/setup
  # https://github.com/account/applications/new
  # https://developer.twitter.com/apps/new
end 
