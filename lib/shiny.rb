require 'readline'
require_relative './client.rb'

module Shiny
  extend self

  def init_client
    @client = Client.instance
    @client.init
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

  def start
    init_client

    while input = Readline.readline("@#{@client.screen_name} # ", true)

      command, args = parse_input(input)

      if check_exit?(command)
        break
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
  end
end
