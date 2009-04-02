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
      preferences
    else
      message[:error] = "User failed to be created"
      render :new
    end
  end

def preferences
	render :preferences
end
end
