require 'parsedate'
class Twit 
  include DataMapper::Resource

  property :id, Serial
  property :twitter_name, String, :unique_index => :twit_user_pair
  property :twitter_password, String
  property :last_id, Integer, :default => 1
  property :percent_friends, Integer, :default => 75
  property :new_tweets, Boolean, :default => false
  property :user_id, Integer, :unique_index => :twit_user_pair

  belongs_to :user
  has n, :friends
  has n, :groups
  has n, :followers

  def get_tweets()
     twitter=Twitter::Base.new(self.twitter_name, self.twitter_password)
     begin
       return true if twitter.rate_limit_status.remaining_hits.to_i == 0
       messages=twitter.timeline( :friends, :since_id => self.last_id)
       unless messages.empty?
         self.last_id = messages[0].id
       end
     rescue Exception => e
     end
     begin
     stored_count = 0
     messages.each do |msg|
         next if self.twitter_name == msg.user.screen_name
         stored_count += 1
         f=Friend.first(:twitter_name => msg.user.screen_name, :twit_id => self.id)
         if not f
           f=Friend.new(:twitter_name => msg.user.screen_name, :twit_id => self.id)
           f.save
           i=Image.new(:url => msg.user.profile_image_url, :friend_id => f.id)
           i.save 
         end
         msg.text =~ /\s(http[^\s]+)/
         if $1
            sub=$1.dup
            msg_save=msg.text.sub(/\shttp[^\s]+/," <a href=\"#{sub}\" target=\"_blank\">#{sub}<\/a>")
         else
				msg_save=msg.text
         end
         t=Tweet.new(:message => msg_save, :sent_date => Time.parse(msg.created_at).strftime("%Y-%m-%d %H:%M:%S"), :friend_id => f.id)
         t.save
     end
     rescue Exception => e
     end
     if stored_count > 0
         self.new_tweets = true
         self.save
     end
     return true
  end
  def get_friends()
    begin
    	twitter = Twitter::Base.new( self.twitter_name,self.twitter_password )
    	friends = twitter.friends()
      followers = twitter.followers()
    rescue Exception => e
      return "and could not query for friends and/or followers #{e.to_s}"
    end
    	unless friends.empty?
      	friends.each do |friend|
		 	 f=Friend.new
        	 f.twitter_name=friend.screen_name
          f.twit=self
          img_url=friend.profile_image_url
          begin
		   	f.save
          rescue Exception => e
            return "and no friends saved due to database error  #{e.to_s}"
		    end
          begin
            im=Image.new
            im.url = img_url
            im.friend = f
            im.save
          rescue Exception => e
            return "friends saved but not images  or followers because #{e.to_s}"
          end
          begin
            followers.each do |fr|
				  follower=Follower.new
              follower.follower_name = fr.screen_name
              follower.twit = self
              follower.save
            end
          rescue Exception => e
					"Friends and friends' images saved but not followers because #{e.to_s}"
          end
        end
     end
     return "and friends friends images and followers saved successfully"
end
  def status(user_id)
        begin
     	  twitter = Twitter::Base.new( self.twitter_name,self.twitter_password )
          user=User.get(user_id)
	  [twitter.rate_limit_status.remaining_hits, self.new_tweets, user.new_search_tweets, user.visual_notify, user.audio_notify, user.tweets_displayed]
        rescue
		["?",false,false]
        end	
  end
  def post_tweet(msg)
    begin
      twitter=Twitter::Base.new(self.twitter_name, self.twitter_password)
      twitter.update msg
      "Message sent successfully."      
    rescue Exception => e
       "Failed to send message because #{e.to_s}"
    end
  end
end
