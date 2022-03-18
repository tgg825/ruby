class String
    def sentences               # \n|\r => line feed & carriage return replaced by a space.  Handles multiline inputs
        gsub(/\n|\r/, ' ').split(/\.\s*/)   # splits sentences based on a period followed by a white space
    end                                     # \.\s* => period followed by 0 or more whitespaces
    def words
        scan(/\w[\w'\-]*/)
    end
end
class WordPlay
    def self.best_sentence(sentences, desired_words)
        ranked_sentences = sentences.sort_by do |s|
            s.words.length - (s.downcase.words - desired_words).length 
        end
        ranked_sentences.last
    end
    def self.switch_pronouns(text)
        text.gsub(/\b(I am|You are|I|You|Me|Your|My)\b/i) do |pronoun|
            case pronoun.downcase 
            when "i"
                "you"
            when "you"
                "me"
            when "me"
                "you"
            when "i am"
                "you are"
            when "you are"
                "i am"
            when "your"
                "my"
            when "my"
                "your"
            end
        end.sub(/^me\b/i, 'i')
    end
end
=begin
# The next section comprises a series of individual tests that were used to test each of the methods in class
# WordPlay as well as the extension to class String with the addition of sentence and word separation methods
# This section to be removed/commented out in the final product.
# Initial tests for sentences method added to class String
p %q{Hello. This is a test of
basic sentence splitting. It
even works over multiple lines.}.sentences
# Initial tests for words method added to class String
p "This is a test of words' capabilities".words
# Combination tests for sentences & words method used in combination to pick the second sentenc & forth word. 
p %q{Hello. This is a test of
    basic sentence splitting. It
    even works over multiple lines.}.sentences[1].words[3]
# Individual tests for selecting best sentence based on some disired or 'hot words'
hot_words = %w{test ruby great}
my_string = "This is a test. Dull sentence here. Ruby is great. So is cake."
puts WordPlay.best_sentence(my_string.sentences, hot_words)
# Initial tests of the pronoun substitution method in WordPlay
puts WordPlay.switch_pronouns("Your cat is fighting with my cat")
puts WordPlay.switch_pronouns("You are my robot")
=end