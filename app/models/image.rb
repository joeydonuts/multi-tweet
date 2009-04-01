class Image 
  include DataMapper::Resource
  
  property :id,     Serial
  property :url,  String
  
  belongs_to :friend
  
end
