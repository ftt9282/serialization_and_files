module Hangman

  class Gameplay
  	def initialize(new_player)
  		@total_guesses = 8
  		@player = Player.new(new_player)
  		@word = Word.new
  	end

  	def start_game
      puts "Welcome to Hangman, #{@player.player_name}. Good luck!"
      show_status
  	end

  	def show_status
      puts "Your hidden word is...\n"
      puts @word.show_hidden_word
      puts "And you have #{@total_guesses} guesses left"
  	end

  end

  class Player
    attr_accessor :player_name

    def initialize(player_name)
    	@player_name = player_name
    end
  end

  class Dictionary
  	attr_reader :dictionary_words

  	def initialize
  	  @dictionary_words = get_words_from_file
  	end

  	def get_words_from_file
      word_array = []
      File.readlines("english_words_basic.txt").each do |line|
        word_array << line
      end
      return word_array
  	end

  end

  class Word
  	attr_reader :hidden_word

    def initialize
      @dictionary = Dictionary.new
      @secret_word = choose_random_word(@dictionary.dictionary_words)
      @hidden_word = mask_secret_word
    end

    def choose_random_word(word_array)
      random_num = rand(word_array.length)
      word_array[random_num]
    end

    def show_hidden_word
      @hidden_word.join("  ")
    end

    def check_for_match(guess)
      flag = false
      @secret_word.split('').each_with_index do |letter, index|
        if letter == guess
        	flag = true
        	update_hidden_word(guess, index)
        end
      end
      flag
    end

    def update_hidden_word(guess, index)
      @hidden_word[index] = guess
    end

    def mask_secret_word
      @hidden_word = ['_'] * @secret_word.length
    end 
  end

end

thing = Hangman::Gameplay.new("Frank")
thing.start_game