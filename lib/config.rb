require 'dotenv'
require 'oauth'
require 'launchy'

module Shiny
  module Configuration
    extend self

    Dotenv.load __dir__ + '/env_variables.env'
    OAUTH_PATH = ENV['HOME'] + '/.shiny_oauth_token'

    def get_token
      if File.exists?(OAUTH_PATH)
        f = File.open(OAUTH_PATH, "r")
        oauth_token = f.gets.strip
        oauth_token_secret = f.gets.strip
        f.close
      else
        options = {:site => 'https://api.twitter.com', :request_endpoint => 'https://api.twitter.com', :authorize_path => '/oauth/authorize'}
        signing_consumer = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], options)
        request_token = signing_consumer.get_request_token

        Launchy.open(request_token.authorize_url)

        pin = Readline.readline('Please enter pin code: ', false)

        access_token = request_token.get_access_token(:oauth_verifier => pin)
        oauth_token, oauth_token_secret = access_token.token, access_token.secret
        File.open(OAUTH_PATH, "w") do |f|
          f.puts oauth_token
          f.puts oauth_token_secret
        end
      end
      return oauth_token, oauth_token_secret
    end

    def get_config
      oauth_token, oauth_token_secret = get_token
      config = {
        consumer_key: ENV['CONSUMER_KEY'],
        consumer_secret: ENV['CONSUMER_SECRET'],
        access_token: oauth_token,
        access_token_secret: oauth_token_secret
      }
    end

  end
end
