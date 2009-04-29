class Tweet 
  include DataMapper::Resource
  
  property :id,     Serial
  property :message, Text
  property :sent_date, DateTime
  property :deleted_at, DateTime, :default => nil
  property :twitter_id, Integer
  property :from_user, Text
  
  belongs_to :friend
end
