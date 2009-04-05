class Image 
  include DataMapper::Resource
  
  property :id,  Serial
  property :url, Text 
  
  belongs_to :friend
  
end
