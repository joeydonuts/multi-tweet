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
    z=@t.get_friends() 
	"Twitter user added successfully #{z}"
  end

  def show(id)
     render
  end
  def list_friends()
     @twit=Twit.get(params[:twit_id]);
     partial(:show_friends)
  end
  def get_status()
     provides :json
     @twit=Twit.get(params[:twit_id])
     user_id=session.user.id
     @twit_status=@twit.status(user_id)
      partial(:status)
  end
  def send_tweet()
    @twit=Twit.get(params[:twit_id])
    if not @twit
        @res="Can't make @twit"
	partial(:tweet_result)
    else
      @res=@twit.post_tweet(params[:msg])
      partial(:tweet_result)
    end
  end
end
