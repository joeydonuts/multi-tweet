require 'parsedate'

class Search 
  include DataMapper::Resource

  property :id, Serial
  property :search_name, String
  property :last_id, Integer, :default => 1;
  property :search_terms, String
  property :seconds_since_last, Integer, :default => 0
  property :search_interval, Integer, :default => 900
  property :last_retrieve_id, Integer, :default => 0

  has n, :searchtweets
  belongs_to :user
  before :destroy, :remove_tweets
  
  def get_tweets(user)
    search_tweets=[]
    max_page_number=2
    default_per_page=49
    query=self.search_terms.gsub(/\s/,'+')
    begin
    a_res=[]
    1.upto(max_page_number) do |page_number|
      Twitter::Search.new(query).since(self.last_id).per_page(default_per_page).page(page_number).each do |msg|
         a_res << msg
      end
    end
    return true if a_res.empty?
    self.last_id = a_res[0].id
    user.new_search_tweets = true
    user.save
    self.save
    a_res.each do |msg|
         msg.text =~ /\s(http[^\s]+)/
         if $1
            sub=$1.dup
            msg_save=msg.text.sub(/\shttp[^\s]+/," <a href=\"#{sub}\" target=\"_blank\">#{sub}<\/a>")
         else
				msg_save=msg.text
         end
         st=Searchtweet.new(:search_id => self.id, :message => msg_save, 
         :sent_date => Time.parse(msg.created_at).strftime("%Y-%m-%d %H:%M:$S"),
         :from_user => msg.from_user, :image_url => msg.profile_image_url, :twitter_id => msg.id)
         st.save
    end
    rescue Exception => e
    end
    return true    
  end
  def readable_tweets(user_id, reset=false, startup=false)
     begin
      a_res=[]
      user=User.get(user_id)
      if startup
        z=self.searchtweets.all(:limit => user.tweets_displayed, :deleted_at => nil,:order => [:sent_date.desc])
      else
        z=self.searchtweets.all(:limit => user.tweets_displayed, :deleted_at => nil,:order => [:sent_date.desc], :id.gt => self.last_retrieve_id)
      end
      z.each do |tweet|
	  a_res << [tweet.image_url, tweet.message, tweet.sent_date.to_s, tweet.twitter_id, tweet.from_user]
      end
      if reset
          user.new_search_tweets=false
          user.save
      end
      unless a_res.empty?
	self.last_retrieve_id = z.first.id 
        self.save
      end
      rescue
       return []
      end
      a_res 
  end
    def remove_tweets()
       repository.adapter.execute('DELETE FROM searchtweets where search_id=?', self.id)
    end
  def get_terms()
	[self.search_name, self.search_terms]
  end
  
end
