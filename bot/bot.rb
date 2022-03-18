require 'yaml'
require_relative 'wordplay'
# This is a basic implementation of a chatterbot as per Chapter 12
# Of the Ruby 3 Text by Carleton Delio & Peter Cooper
# Most of the comments are by the authors with occasional additions 
# by myself for academic purposes: T. G. Greenwood during the C4V
# academic programme.
class Bot
    attr_reader :name 
    def initialize(options)
        @name = options[:name] || "Unnamed Bot"
        begin
            @data = YAML.load(File.open(options[:data_file]).read)
        rescue
            raise "Can't load bot data"
        end
    end
    # Return a random greeting
    def greeting
        random_response :greeting
    end
    # Return a random farewell
    def farewell
        random_response :farewell
    end
    def response_to(input)
        prepared_input = preprocess(input.downcase)
        sentence = best_sentence(prepared_input)
        reversed_sentence = WordPlay.switch_pronouns(sentence)
        responses = possible_responses(sentence)
        responses[rand(responses.length)]
    end
    # Choose a random reponse phrase from the :response hash
    # and substitutes metadata into the phrase
    private
    # Chooses a random response phrase from the :responses hash
    # and substitutes metadata into the phrase
    def random_response(key)
        random_index = rand(@data[:responses][key].length)
        @data[:responses][key][random_index].gsub(/\[name\]/, @name)
    end
    # Performs preprocessing tasks upon all input to the bot
    def preprocess(input)
        perform_substitutions(input)
    end
    # Substitutes words and phrases on supplied input as dictated by
    # the bot's :presubs data
    def perform_substitutions(input)
        @data[:presubs].each { |s| input.gsub!(s[0], s[1]) }
        input 
    end
    # Using the single word keys from :responses, we search for the
    # sentence that uses the greatest number of them, as it's likely to be the
    # 'best' sentence to parse
    def best_sentence(input)
        hot_words = @data[:responses].keys.select do |k|
            k.class == String && k =~ /^\w+$/
        end
        WordPlay.best_sentence(input.sentences, hot_words)
    end
    # Using a supplied sentence, go through the bot's :responses
    # data set and collect together all phrases that could be
    # used as responses
    def possible_responses(sentence)
        responses = []
        #Find all patterns to try to match against
        @data[:responses].keys.each do |pattern|
            next unless pattern.is_a?(String)
            # For each pattern, see if the supplied sentence contains
            # a match. Remove all substitution symbols (*) before checking
            # Push all responses to the reponses array. 
            if sentence.match('\b' + pattern.gsub(/\*/, '') + '\b')
                # If the pattern contains the substitution placeholders,
                # perform the substitutions
                if pattern.include?('*')
                    responses << @data[:responses][pattern].collect do |phrase|
                        # First erase everything before the placeholder
                        # leaving everything after it. 
                        matching_section = sentence.sub(/^.*#{pattern}\s+/, '')
                        # Then substitute the text afte the placeholder, with
                        # pronouns switched 
                        phrase.sub('*', WordPlay.switch_pronouns(matching_section))
                    end
                else
                    # No placeholders? Just add the phrases to the array
                    responses << @data[:responses][pattern]
                end
            end
        end
        # If there are no matches, add the default ones
        responses << @data[:responses][:default] if responses.empty? 
        # Flatten the blocks of teh responses to a flat array
        responses.flatten 
    end
end