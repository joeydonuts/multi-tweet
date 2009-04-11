require 'parsedate'
class Twit 
  include DataMapper::Resource

  property :id, Serial
  property :twitter_name, String, :unique_index => :twit_user_pair
  property :twitter_password, String
  property :last_id, Integer, :default => 1
  property :percent_friends, Integer, :default => 75
  property :new_tweets, Boolean, :default => false
  property :new_search_tweets, Boolean, :default => false
  property :user_id, Integer, :unique_index => :twit_user_pair

  belongs_to :user
  has n, :friends
  has n, :groups
  has n, :followers
  has n, :searches

  def groups()
    group_array=[]
    self.friends.groups.each do |item|
       group_array << item.group
    end
    group_array.uniq! unless group_array.empty?
    group_array
  end
  def get_tweets()
     twitter=Twitter::Base.new(self.twitter_name, self.twitter_password)
     messages=twitter.timeline( :friends, :since_id => self.last_id)
     unless messages.empty?
         self.last_id = messages[0].id
         self.save
     end
     messages.each do |msg|
     next if self.twitter_name == msg.user.screen_name
         f=Friend.first(:twitter_name => msg.user.screen_name, :twit_id => self.id)
         if not f
           f=Friend.new(:twitter_name => msg.user.screen_name)
           f.twit = self
           f.save
           i=Image.new
           i.url=msg.user.profile_image_url
           i.friend=f
           i.save 
         end
         
         t=Tweet.new()
         t.message = msg.text
         t.sent_date = convert_twit_time(msg.created_at)
         t.friend_id=f.id
         t.save
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
private
    def convert_twit_time(s)
      year,mon,day,hr,min,sec,offset,zone=ParseDate::parsedate(s)
      "#{year}-#{mon}-#{day} #{hr}:#{min}:#{sec}"
    end
end
