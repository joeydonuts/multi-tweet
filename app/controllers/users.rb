class Users < Application

  before :ensure_authenticated, :exclude => [:new, :create]

  def index
   # if current_user
      disp_limit=session.user.tweets_displayed
      @twits=session.user.twits
      @groups_by_twit = {}
      @twits.each do |twit|
        htemp={}
        twit.groups.each do |group|
          temp_tweets=[]
          tweets=Tweet.readable(group.id,disp_limit)
          unless tweets.empty?
            tweets.each do |ts|
              temp_tweets << [ts.mesage,ts.send_date,ts.friend.image]
            end
          end
         htemp[group] = temp_tweets
      end
        @groups_by_twit[twit.twitter_name] = htemp
      end
      if @groups_by_twit.empty?
	    	show
      else
        render
      end
    #    render
    #end
  end

  def new
    only_provides :html
    @user = User.new
    display @user
  end
 
 def create()
    user=params[:user]
    @user = User.new(user)
    if @user.save
      session[:user] = @user.id
      show()
    else
      message[:error] = "User failed to be created"
      render :new
    end
  end
def show()
   @user=session.user unless @user
   @twits=session.user.twits
   @searches=session.user.twits.searches
   render :preferences
end

end
