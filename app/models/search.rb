require 'parsedate'

class Search 
  include DataMapper::Resource

  property :id, Serial
  property :search_name, String
  property :last_id, Integer, :default => 1;
  property :search_terms, String
  property :seconds_since_last, Integer, :default => 0
  property :search_interval, Integer, :default => 900

  has n, :searchtweets
  belongs_to :user
  
  def get_tweets(user)
    search_tweets=[]
    max_page_number=2
    default_per_page=49
    query=self.search_terms.gsub(/\s/,'+')
    begin
    1.upto(max_page_number) do |page_number|
     count=0
      Twitter::Search.new(query).since(self.last_id).per_page(default_per_page).page(page_number).each do |msg|
         self.last_id = msg.id if count == 0
         self.user.new_search_tweets = true if count == 0
         self.user.save if count == 0
         self.save
         count += 1
         msg.text =~ /\s(http[^\s]+)/
         if $1
            sub=$1.dup
            msg_save=msg.text.sub(/\shttp[^\s]+/," <a href=\"#{sub}\" target=\"_blank\">#{sub}<\/a>")
         else
				msg_save=msg.text
         end
          st=Searchtweet.new(:search_id => self.id, :message => msg_save, 
          :sent_date => Time.parse(msg.created_at).strftime("%Y-%m-%d %H:%M:$S"),:sender => msg.from_user, :image_url => msg.profile_image_url)
          st.save
      end
    end
    rescue Exception => e
    end
  end
  def readable_tweets(reset=false)
      a_res=[]
      self.searchtweets.each do |tweet|
	  a_res <<[tweet.image_url, tweet.message, tweet.sent_date.to_s]
      end
      if reset
          self.user.new_search_treats=false
          self.user.save
      end
      a_res.sort!{|a,b| b[2] <=> a[2]}
      return a_res[0...self.user.tweets_displayed] 
  end
end
