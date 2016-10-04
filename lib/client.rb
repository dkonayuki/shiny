require 'singleton'
require 'twitter'
require_relative './config.rb'
require_relative './ext/string'
require_relative './ext/time'

module Shiny
  class Client
    include Singleton

    def init
      #@client = Twitter::Streaming::Client.new(Configuration.get_config)
      @client = Twitter::REST::Client.new(Configuration.get_config)
    end

    def print_tweet(tweet)
      puts "#{tweet.user.name.orange.bold} @#{tweet.user.screen_name} #{tweet.created_at.time_ago.base03}"
      puts "#{tweet.text}"
      puts "₪:#{tweet.retweet_count.to_s.blue} ❤:#{tweet.favorite_count.to_s.red}"
      puts ""
    end

    def home(args)
      if args[0] == nil
        # return the 20 most recent tweets
        tweets = @client.home_timeline
      else
        tweets = @client.home_timeline({count: args[0]})
      end

      # asc order
      tweets.sort_by! { |tweet| tweet.created_at.to_i }

      tweets.each do |tweet|
        print_tweet(tweet)
      end
    end

    def favorite(args)

    end

    def tweet(args)
      @client.update(args.join(' '))
    end

    def friends(args)
      if args[0] != nil
        friends = @client.friends.take(args[0].to_i)
      else
        friends = @client.friends.to_a
      end
      friends.each do |friend|
        puts friend.name
      end
    end

    def user
      @client.user
    end

    def screen_name
      @client.user.screen_name
    end

  end
end
