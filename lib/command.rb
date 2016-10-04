require_relative 'ext/string'
require_relative 'ext/time'

module Shiny
  module Command
    extend self

    def print_tweet(tweet)
      puts "#{tweet.user.name} @#{tweet.user.screen_name} #{tweet.created_at.time_ago.blue}"
      puts "#{tweet.text.base00}"
      puts "₪:#{tweet.retweet_count.to_s.base03} ❤:#{tweet.favorite_count.to_s.orange}"
      puts ""
    end

    def home(client, args)
      if args[0] == nil
        # return the 20 most recent tweets
        tweets = client.home_timeline
      else
        tweets = client.home_timeline({count: args[0]})
      end

      # asc order
      tweets.sort_by! { |tweet| tweet.created_at.to_i }

      tweets.each do |tweet|
        print_tweet(tweet)
      end
    end

    def tweet(client, args)
      client.update(args.join(' '))
    end

    def friends(client, args)
      if args[0] != nil
        friends = client.friends.take(args[0].to_i)
      else
        friends = client.friends.to_a
      end
      friends.each do |friend|
        puts friend.name
      end
    end
  end
end
