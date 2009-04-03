class Users < Application

  before :ensure_authenticated, :exclude => [:new, :create]

  def index
    render
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
  def create_twitter_user()
   t=Twit.new
   t.twitter_name=params[:twitter_name]
   t.twitter_password=params[:twitter_password]
   t.user=session.user
   begin
   	t.save
   rescue
		return "Could not add twitter user"
   end
		"Twitter user added successfully."
  end
def show()
   @twits=session.user.twits
   @searches=session.user.searches
   render :preferences
end

end
