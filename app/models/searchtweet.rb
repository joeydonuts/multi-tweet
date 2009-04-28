class Searchtweet 
  include DataMapper::Resource
  
  property :id,     Serial
  property :message, Text
  property :sent_date, DateTime
  property :sender, String, :limit => 140
  property :image_url, Text
  property :deleted_at, DateTime, :default => nil
  property :twitter_id, Integer
  
  belongs_to :search
  
end
