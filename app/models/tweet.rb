class Tweet 
  include DataMapper::Resource
  
  property :id,     Serial
  property :message,  Text
  property :sent_date, DateTime
  property :deleted_at, DateTime, :default => nil
  
  belongs_to :friend
  def self.readable(group_id, disp_limit)
     self.all(:order => :sent_date.desc, :limit => disp_limit, :group_id => group_id)
  end  
end
