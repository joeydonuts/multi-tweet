class Follower
  include DataMapper::Resource
  
  property :id,     Serial
  property :follower_name,  String, :unique_index => :twit_follower_pair
  property :twit_id, Integer, :unique_index => :twit_follower_pair  
  belongs_to :twit 
end
