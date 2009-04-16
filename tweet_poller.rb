
class Tweet_poller
def self.start
  Thread.new do
    loop{
    users=User.all()
    threads=[]
    users.each do |user|
      next if user.twits.empty?
      threads << Thread.new(user){
          user.twits.each do |twit|
            twit.get_tweets
          end
       }
      user.searches.each do |search|
        search.get_tweets(user)
      end 

    end #end of users.each
    threads.each do |t|
       t.join
    end #end of threads each
    sleep(60)
    } #end of loop
  end #end of main thread
end #end of def self.start
end
