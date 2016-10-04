module Shiny
  module Utilities
    extend self

    def print_tweet(tweet)
      puts "#{tweet.user.name.orange.bold} @#{tweet.user.screen_name} #{tweet.created_at.time_ago.base03}"
      puts "#{tweet.text}"
      puts "id:#{tweet.id} ₪:#{tweet.retweet_count.to_s.blue} ❤:#{tweet.favorite_count.to_s.red}"
      puts ""
    end
  end
end
