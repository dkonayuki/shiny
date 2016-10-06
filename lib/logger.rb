require 'logger'
require 'singleton'

module Shiny
  class Logger
    include Singleton

    LOG_PATH = '/tmp/shiny.log'

    %w(info warning error).each do |method_name|
      define_method(method_name) do |message|
        @logger.public_send(method_name, message)
      end
    end

    def init
      begin
        @logger = ::Logger.new(LOG_PATH)
      rescue => e
        raise "Failed to initialize logger. #{e.message}", e.backtrace
      end
    end

  end
end
