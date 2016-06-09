require 'twitter'
require 'dotenv'
require "readline"

Dotenv.load __dir__ + '/env_variables.env'

def init_client
  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
  end
end

def check_exit?(input)
  if input == 'q'
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

init_client
while input = Readline.readline("@#{@client.user.name} # ", true)

  command, args = parse_input(input)

  if check_exit?(command)
    break
  end

  case command
  when 'tweet'
    @client.update(args.join(' '))
  when 'show'
    puts 'show'
  when 'friends'
    if args[0] != nil
      friends = @client.friends.take(args[0].to_i)
    else
      friends = @client.friends.to_a
    end
    friends.each do |friend|
      puts friend.name
    end
  else 
    puts 'Unrecognized command'
  end

end

