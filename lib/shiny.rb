require 'readline'
require_relative './client.rb'
require_relative './stream.rb'

module Shiny
  extend self

  def init_client
    @client = Client.instance
    @client.init
  end

  def init_stream
    @stream = Stream.instance
    @stream.init
  end

  def check_exit?(input)
    if input == 'q'
      return true
    end
    case input
    when 'q', 'exit'
      return true
    end
    false
  end

  def parse_input(input)
    arr = []
    input = input.strip

    arr = input.split(' ')
    return arr[0], arr[1..arr.length]
  end

  # Exit all the threads
  def terminate
    Thread.list.each do |thread|
      thread.exit
    end
  end

  def start
    init_client
    init_stream

    stream_thread = Thread.new {
      @stream.user do |object|
        case object
        when Twitter::Tweet
          puts "It's a tweet!"
        when Twitter::DirectMessage
          puts "It's a direct message!"
        when Twitter::Streaming::StallWarning
          warn "Falling behind!"
        end
      end
    }

    api_thread = Thread.new {
      while input = Readline.readline("@#{@client.screen_name} # ", true)

        command, args = parse_input(input)

        if check_exit?(command)
          terminate
        end

        case command
        when 'tweet'
          @client.tweet(args)
        when 'home'
          @client.home(args)
        when 'friends'
          @client.friends(args)
        else 
          puts 'Unrecognized command'
        end

      end
    }

    stream_thread.join
    api_thread.join

  end
end
