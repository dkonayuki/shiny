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

    def home(count = 20)
      tweets = @client.home_timeline({count: count})

      # asc order
      tweets.sort_by! { |tweet| tweet.created_at.to_i }

      tweets.each do |tweet|
        Utilities.print_tweet(tweet, { time: :time_ago })
      end
    end

    def favorite(id)
      @client.favorite([id])
      Utilities.print_log("Favorited tweet id: #{id}.")
    rescue => e
      raise "Failed to favorite tweet id: #{id}. #{e.message}", e.backtrace
    end

    def unfavorite(id)
      @client.unfavorite([*id])
      Utilities.print_log("Unfavorited tweet id: #{id}.")
    rescue => e
      raise "Failed to favorite tweet id: #{id}. #{e.message}", e.backtrace
    end

    def follow(list)
      @client.follow(list)
      Utilities.print_log("Users followed: #{list.join(',')}.")
    rescue => e
      raise "Failed to follow #{list.join(',')}. #{e.message}", e.backtrace
    end

    def unfollow(list)
      @client.unfollow(list)
      Utilities.print_log("Users unfollowed: #{list.join(',')}.")
    rescue => e
      raise "Failed to unfollow #{list.join(',')}. #{e.message}", e.backtrace
    end

    def delete(id)
      @client.destroy_status(id)
      Utilities.print_log("Tweet id:#{id} was deleted.")
    end

    def tweet(message)
      @client.update(message)
    end

    def followings(count = 0)
      if count != 0
        users = @client.friends.take(count)
      else
        users = @client.friends.to_a
      end
      Utilities.print_followings(users)
    end

    def user
      @client.user
    end

    def screen_name
      @client.user.screen_name
    end

  end
end
