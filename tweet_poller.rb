#! /usr/bin/ruby
require 'rubygems'
require 'twitter'
require 'dm-core'
require 'dm-validations'

sfile=File.expand_path(__FILE__)
sfile=~/(.*\/)[^\/]*$/
spath=$1
Dir.chdir(spath)

Dir.foreach('app/models') do |fname|
 unless fname =~/^\./
   eval("require \'app/models/#{fname}\'")
 end
end
DataMapper.setup(:default, "sqlite3:multi-development.db")
users=User.all()
threads=[]
users.each do |user|
  next if user.twits.empty?
    threads << Thread.new(user){
      DataMapper.setup(:default, "sqlite3:multi-development.db")
        user.twits.each do |twit|
          twit.get_tweets
        end
        user.searches.each do |search|
          search.get_tweets(user)
        end
    }
end
 threads.each do |t|
    t.join
 end

