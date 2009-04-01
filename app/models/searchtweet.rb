class Searchtweet 
  include DataMapper::Resource
  
  property :id,     Serial
  property :message,  String
  property :sent_date, DateTime
  property :sender, String
  property :image_url, String
  property :deleted_at, DateTime, :default => nil
  
  belongs_to :search
  
end
