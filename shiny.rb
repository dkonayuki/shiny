require 'twitter'
require 'readline'
require './config.rb'

def init_client
  @client = Twitter::REST::Client.new(Config.get_config)
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
#bearer_token = @client.token
#puts bearer_token
#oauth = Twitter::OAuth.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])
#token = oauth.request_token.token
#puts token

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

