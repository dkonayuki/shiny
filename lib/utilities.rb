module Shiny
  module Utilities
    extend self

    def print_tweet(tweet, options = {})
      if options[:time] == :time_ago
        puts "  #{tweet.user.name.orange.bold} @#{tweet.user.screen_name} #{tweet.created_at.time_ago.base01}"
      else
        puts "  #{tweet.user.name.orange.bold} @#{tweet.user.screen_name} #{tweet.created_at.dup.localtime.strftime('%Y-%m-%d %H:%M:%S').base01}"
      end
      puts "    #{tweet.text}"
      puts "    id:#{tweet.id} ₪:#{tweet.retweet_count.to_s.blue} ❤:#{tweet.favorite_count.to_s.red}"
    end

    def print_api_tweet(tweet)
      print_tweet(tweet, { time: :time_ago })
      puts ""
    end

    def print_stream_tweet(tweet)
      puts ""
      print_tweet(tweet)
    end

    def print_log(message)
      puts "  #{message.base1.italic}"
    end

    def print_followings(users)
      users.each do |user|
        puts user.name
      end
    end

  end
end
