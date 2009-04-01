class Friend 
  include DataMapper::Resource
  
  property :id,     Serial
  property :twitter_name,  String
  belongs_to :twit
  has n, :tweets
  has n, :groups, :through => Resource
  
end
