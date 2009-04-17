class Users < Application

  before :ensure_authenticated, :exclude => [:new, :create]

  def index
   # if current_user
      disp_limit=session.user.tweets_displayed
      @twits=session.user.twits
      @searches=session.user.searches
      if @twits.empty? and @searches.empty?
	    	show
      else
        render
      end
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
