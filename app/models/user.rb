# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  
  property :id,     Serial
  property :login,  String
  property :visual_notify, Boolean, :default => true
  property :audio_notify, Boolean, :default => false
  property :tweet_query_pct, Integer, :default => 75
  property :tweets_displayed, Integer, :default => 100
 
  validates_is_unique :login
  has n, :twits
  has n, :searches
end
