class Group 
  include DataMapper::Resource

  property :id, Serial
  property :group_name, String
  has n, :friends, :through => Resource
  
  def readable_tweets
    a_res=[]
    return a_res 
  end
end
