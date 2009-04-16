# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '6ec7689eb1c2afdba300cb45c72ac585e7b82e07'  # required for cookie session store
  c[:session_id_key] = '_multi-tweet_session_id' # cookie session id key, defaults to "_session_id"
  c[:path_prefix] = nil
  c[:environment] = 'development'
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
   require Merb::Config[:merb_root] + '/tweet_poller.rb'
   Tweet_poller.start
end
