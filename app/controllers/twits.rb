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

private
end
