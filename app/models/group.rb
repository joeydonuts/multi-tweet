class Group 
  include DataMapper::Resource

  property :id, Serial
  property :group_name, String
  has n, :friends, :through => Resource
  belongs_to :twit
   
  def readable_tweets(twit,reset_new_tweets=false)
    a_res=[]
    z=self.friends.tweets.all(:deleted_at => nil, :order => [:sent_date.desc], :limit => twit.user.tweets_displayed)
    z.each do |tweet|
       url=tweet.friend.image.url
       a_res << [url, tweet.message, tweet.sent_date.to_s]
    end
    if reset_new_tweets
      twit.new_tweets=false
      twit.save
    end
    a_res 
  end
end
