class Searchtweet 
  include DataMapper::Resource
  
  property :id,     Serial
  property :message, Text
  property :sent_date, DateTime
  property :sender, String
  property :image_url, Text
  property :deleted_at, DateTime, :default => nil
  
  belongs_to :search
  
end
