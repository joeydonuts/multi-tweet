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
    rescue
      return "and could not query for friends"
    end
    	unless friends.empty?
      	friends.each do |friend|
		 	 f=Friend.new
        	 f.twitter_name=friend.screen_name
          f.twit=@t
          img_url=friend.profile_image_url
          begin
		   	f.save
            i=Image.new
            i.friend=f
            i.url = img_url
            i.save
          rescue
            return "and no friends saved due to database error"
		    end
        end
     end
     return "and friends saved successfully"
end
end
