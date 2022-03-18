require_relative 'bot'
# This is a basic implementation of a chatterbot as per Chapter 12
# Of the Ruby 3 Text by Carleton Delio & Peter Cooper
# Most of the comments are by the authors with occasional additions 
# by myself for academic purposes: T. G. Greenwood during the C4V
# academic programme.  It was run correctly (no errors) on 
# a MacBook Pro OSX 11.6 via both command line (Terminal) and in 
# Ruby Extension in VSCode v1.60.2
# bot = Bot.new(name: 'Fred', data_file: 'fred.bot')    # Hardwire bot name and file into the client program
bot = Bot.new(name: ARGV[0], data_file: ARGV[1])    # Cmd line -> ruby basic_client.rb Fred fred.bot
puts bot.greeting
while input = $stdin.gets and input.chomp != 'end'
    puts '>> ' + bot.response_to(input)
end
puts bot.farewell