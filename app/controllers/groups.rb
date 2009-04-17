class Groups < Application

  def index
    render
  end
  def show
    render
  end
  def new
    @group=Group.new
    @group.group_name = params[:group_name]
    @group.twit_id = params[:twit_id]
    @group.save
    friend_ids = params[:friend_list].split(/\^\^/)
    friend_ids.each do |friend_id|
      f = Friend.get(friend_id)
      @group.friends << f
      @group.save
    end
    partial(:new_group)
  end
  def update
    render
  end
  def get_group_tweets
      @group=Group.first(:group_name => params[:group_name], :twit_id => params[:twit_id])
      @twit=Twit.get(params[:twit_id])
      @tweets=@group.readable_tweets(@twit, params[:reset])
      partial(:tweets)
  end
  def destroy
    render
  end  
end
