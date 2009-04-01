class Search 
  include DataMapper::Resource

  property :id, Serial
  property :search_name, String
  property :last_id, Integer
  property :search_terms, String
  property :seconds_since_last, Integer, :default => 0
  property :search_interval, Integer, :default => 900

  has n, :searchtweets
  belongs_to :twit

end
