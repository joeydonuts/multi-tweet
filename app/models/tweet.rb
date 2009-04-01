class Tweet 
  include DataMapper::Resource
  
  property :id,     Serial
  property :message,  String
  property :sent_date, DateTime
  property :deleted_at, DateTime, :default => nil
  
  belongs_to :friend
  
end
