require 'twitter'
require 'dotenv'

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

def prepare_promt
  print "\n"
  print '> '
end

init_client
print '> '

while input = gets do

  command, args = parse_input(input)

  if check_exit?(command)
    break
  end

  case command
  when 'tweet'
    @client.update(args.join(' '))
  when 'show'
    puts 'show'
  else 
    puts 'Unrecognized command'
  end

  prepare_promt
end

