class Follower
  include DataMapper::Resource
  
  property :id,     Serial
  property :follower_name,  String
  
end
