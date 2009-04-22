class Searches < Application

  def index
    render
  end
  def new
      @search=Search.new(:search_name => params[:search_name], :search_terms => params[:search_term], :user => session.user)
      @search.save
      partial(:new_search)
  end  
  def get_new_searches()
    @search=Search.get(params[:search_id])
    user_id=session.user.id
    @search_tweets=@search.readable_tweets(user_id, params[:reset])
    partial(:new_searches)
  end
end
