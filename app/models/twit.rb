class Twit 
  include DataMapper::Resource

  property :id, Serial
  property :twitter_name, String
  property :twitter_password, String
  property :last_id, Integer
  property :percent_friends, Integer, :default => 75
  property :new_tweets, Boolean, :default => false
  property :new_search_tweets, Boolean, :default => false

  belongs_to :user
  has n, :friends
  has n, :groups
  has n, :followers
end
