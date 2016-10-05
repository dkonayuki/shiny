module Shiny
  module Utilities
    extend self

    def print_tweet(tweet, options = {})
      if options[:time] == :time_ago
        puts "#{tweet.user.name.orange.bold} @#{tweet.user.screen_name} #{tweet.created_at.time_ago.base03}"
      else
        puts "#{tweet.user.name.orange.bold} @#{tweet.user.screen_name} #{tweet.created_at.dup.localtime.strftime('%Y-%m-%d %H:%M:%S').base03}"
      end
      puts "#{tweet.text}"
      puts "id:#{tweet.id} ₪:#{tweet.retweet_count.to_s.blue} ❤:#{tweet.favorite_count.to_s.red}"
      puts ""
    end

  end
end
