class Group 
  include DataMapper::Resource

  property :id, Serial
  property :group_name, String
  property :last_retrieve_id, Integer, :default => 0

  has n, :friends, :through => Resource
  belongs_to :twit
   
  def readable_tweets(twit,reset_new_tweets=false, startup=false)
    a_res=[]
    if startup
      z=self.friends.tweets.all(:deleted_at => nil, :order => [:sent_date.desc], :limit => twit.user.tweets_displayed)
    else
      z=self.friends.tweets.all(:deleted_at => nil, :order => [:sent_date.desc], :limit => twit.user.tweets_displayed, :id.gt => self.last_retrieve_id)
    end
    z.each do |tweet|
       url=tweet.friend.image.url
       a_res << [url, tweet.message, tweet.sent_date.to_s, tweet.twitter_id, tweet.from_user]
    end
    unless a_res.empty?
      self.last_retrieve_id = z.first.id
      self.save
    end
    if reset_new_tweets
      twit.new_tweets = false
      twit.save
    end
    a_res 
  end
end
