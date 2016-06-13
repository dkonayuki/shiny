require 'twitter'
require 'readline'
require __dir__ + '/config'
require __dir__ + '/command'

module Shiny
  extend self

  def init_client
    @client = Twitter::REST::Client.new(Configuration.get_config)
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

    while input = Readline.readline("@#{@client.user.name} # ", true)

      command, args = parse_input(input)

      if check_exit?(command)
        break
      end

      case command
      when 'tweet'
        Command.tweet(@client, args)
      when 'home'
        Command.home(@client, args)
      when 'friends'
        Command.friends(@client, args)
      else 
        puts 'Unrecognized command'
      end

    end
  end
end
