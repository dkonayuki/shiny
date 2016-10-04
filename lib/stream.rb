require 'singleton'
require 'twitter'
require_relative './config.rb'
require_relative './ext/string'
require_relative './ext/time'

module Shiny
  class Stream
    include Singleton

    def init
      @stream = Twitter::Streaming::Client.new(Configuration.get_config)
    end

    def user(&block)
      @stream.user(&block)
    end

  end
end
