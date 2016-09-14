require_relative 'ext/string'

module Shiny
  module Command
    extend self

    def print_tweet(tweet)
      puts "#{tweet.text}"
      puts "₪:#{tweet.retweet_count.to_s.base03} ❤:#{tweet.favorite_count}"
      puts ""
    end

    def home(client, args)
      if args[0] == nil
        # return the 20 most recent tweets
        tweets = client.home_timeline
      else
        tweets = client.home_timeline({count: args[0]})
      end
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
