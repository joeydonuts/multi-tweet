class Searchtweet 
  include DataMapper::Resource
  
  property :id,     Serial
  property :message, Text
  property :sent_date, DateTime
  property :image_url, Text
  property :deleted_at, DateTime, :default => nil
  property :twitter_id, Integer
  property :from_user, Text
  
  belongs_to :search
  
end
