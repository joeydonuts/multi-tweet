class Twits < Application

  def index
    render
  end
  def create()
   @t=Twit.new
   @t.twitter_name=params[:twitter_name]
   @t.twitter_password=params[:twitter_password]
   @t.user=session.user
   begin
   	@t.save
   rescue
		return "Could not add twitter user data base failure! "
   end
   z=get_friends() 
	"Twitter user added successfully #{z}"
  end

private
  def get_friends()
    begin
    	twitter = Twitter::Base.new( @t.twitter_name,@t.twitter_password )
    	friends = twitter.friends()
      followers = twitter.followers()
    rescue Exception => e
      return "and could not query for friends and/or followers #{e.to_s}"
    end
    	unless friends.empty?
      	friends.each do |friend|
		 	 f=Friend.new
        	 f.twitter_name=friend.screen_name
          f.twit=@t
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
              follower.twit = @t
              follower.save
            end
          rescue Exception => e
					"Friends and friends' images saved but not followers because #{e.to_s}"
          end
        end
     end
     return "and friends friends images and followers saved successfully"
end
end
