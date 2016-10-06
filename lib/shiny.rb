require 'readline'
require_relative './client.rb'
require_relative './stream.rb'
require_relative './utilities.rb'
require_relative './logger.rb'

module Shiny
  extend self

  def init_client
    @client = Client.instance
    @client.init
    @logger.info('Initialize twitter client')
  end

  def init_stream
    @stream = Stream.instance
    @stream.init
    @logger.info('Initialize twitter stream')
  end

  def init_logger
    @logger = Logger.instance
    @logger.init
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

  # Exit all threads
  def terminate
    @logger.info('Terminate all threads')
    Thread.list.each do |thread|
      thread.exit
    end
  end

  def start
    init_logger

    @logger.info('Shiny started')
    init_client
    init_stream

    stream_thread = Thread.new {
      @stream.user do |object|
        case object
        when Twitter::Tweet
          Utilities.print_stream_tweet(object)
        when Twitter::DirectMessage
          puts "It's a direct message!"
        end
      end
    }

    api_thread = Thread.new {
      prompt = "@#{@client.screen_name} "
      while input = Readline.readline("#{prompt.base1} #{'$'.base2} ", true)

        @logger.info("Inputed: #{input}")
        command, args = parse_input(input)

        if check_exit?(command)
          terminate
        end

        case command
        when 'tweet'
          @client.tweet(args.join(' '))
        when 'home'
          @client.home(args[0].to_i)
        when 'followings'
          @client.followings(args == nil ? 0 : args[0].to_i)
        when 'delete'
          @client.delete(args)
        when 'follow'
          args.map! { |name| name.gsub(/@/,'') }
          @logger.info("Call follow method with args: #{args}")
          @client.follow(args)
        when 'unfollow'
          args.map! { |name| name.gsub(/@/,'') }
          @logger.info("Call unfollow method with args: #{args}")
          @client.unfollow(args)
        else 
          puts "Unrecognized command: #{command}"
        end

      end
    }

    stream_thread.join
    api_thread.join
  rescue => e
    @logger.info('Shiny ended') unless @logger.nil?
    puts e.message
    puts e.backtrace
    exit 1
  end
end
