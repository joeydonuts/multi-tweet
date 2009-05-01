class Searches < Application

  def index
    render
  end
  def new
      @search=Search.new(:search_name => params[:search_name], :search_terms => params[:search_term], :user => session.user)
      @search.save
      partial(:new_search)
  end  
  def destroy()
    @search = Search.get(params[:search_id])
    @search.destroy
    partial(:destroy_search)
  end
  def update()
     @search = Search.get(params[:search_id])
     @search.search_name=params[:search_name]
     @search.search_terms=params[:search_terms]    
     begin
	@search.save
	@res="Successfully updated search"
     rescue Exception => e
	@res= e.to_s
     end
     partial(:update_search)
  end
  def get_new_searches()
    @search=Search.get(params[:search_id])
    user_id=session.user.id
    @search_tweets=@search.readable_tweets(user_id, params[:reset])
    partial(:new_searches)
  end
  def get_search_terms()
     @search=Search.get(params[:search_id])
     @results=@search.get_terms()
     partial(:edit_search)
  end
end
