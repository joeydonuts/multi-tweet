class Group 
  include DataMapper::Resource

  property :id, Serial
  property :group_name, String
  has n, :friends, :through => Resource
  
  def readable_tweets(twit)
    a_res=[]
    self.friends.each do |friend|
        url=friend.image.url
        z=friend.tweets.all(:deleted_at => nil)
        z.each do |tweet|
          a_res << [url, tweet.message, tweet.sent_date.to_s]
        end
    end
    a_res.sort!{|a,b| b[2] <=> a[2]}
    return a_res[0...twit.user.tweets_displayed] 
  end
end
