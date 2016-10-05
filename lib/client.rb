require 'singleton'
require 'twitter'
require_relative './config.rb'
require_relative './ext/string'
require_relative './ext/time'
require_relative './utilities.rb'

module Shiny
  class Client
    include Singleton

    def init
      @client = Twitter::REST::Client.new(Configuration.get_config)
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
        Utilities.print_tweet(tweet, { time: :time_ago })
      end
    end

    def favorite(args)

    end

    def delete(args)
      @client.destroy_status(args[0])
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
