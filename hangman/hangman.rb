module Hangman
  
  require 'yaml'

  class Gameplay
  	def initialize(new_player)
  		@total_guesses = 8
  		@player = Player.new(new_player)
  		@word = Word.new
  	end

  	def start_game
      puts "\nWelcome to Hangman, #{@player.player_name}. Good luck!\n"
      while @total_guesses > 0
        show_status
        puts "Save/Load your game? Type 'yes' to do so"
        save_or_load if gets.chomp == 'yes'
        puts "Guess a letter! Let's see if it matches."
        guess_letter(gets.chomp)
        winning_prompt if check_for_winner(@word.secret_word, @word.hidden_word.join(''))
      end
      puts "The hidden word was #{@word.secret_word}"
      exit
  	end

  	def show_status
      puts "Your hidden word is...\n"
      puts @word.show_hidden_word
      puts "And you have #{@total_guesses} guesses left\n"
  	end

  	def guess_letter(letter)
      until letter.match(/^[[:alpha:]]$/) && letter.length == 1
      	puts "Input is invalid. Try again."
      	letter = gets.chomp
      end
      process_guess(@word.check_for_match(letter)) ? "\nYou guessed correct!" : "\nIncorrect guess."
  	end

  	def process_guess(correct)
      if correct
      	puts "\nYou guessed correct!"
      else
      	puts "\nIncorrect guess."
      	@total_guesses -= 1
      end
  	end

  	def check_for_winner(secret_word, letters_guessed)
      if secret_word == letters_guessed
      	true
      end
  	end

  	def winning_prompt
      puts "You won! You won! You won!"
      exit
  	end

  	def save_or_load
  	  puts "Type 'save' to save and 'load' to load"
  	  choice = gets.chomp
      if choice == 'save'
        save_game
      else
        load_game
      end
  	end

  	def save_game
      Dir.mkdir('saved_games') unless Dir.exists? "saved_games"
      file = "saved_games/saved.yaml"
      File.open(file, "w+"){|f| f.puts YAML.dump(self) }
      puts "Game saved."
    end

    def load_game
      game_file = File.open("saved_games/saved.yaml")
      yaml = game_file.read
      game_loaded = YAML::load(yaml)
      game_loaded.start_game
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
  	attr_reader :hidden_word, :secret_word

    def initialize
      @dictionary = Dictionary.new
      @secret_word = choose_random_word(@dictionary.dictionary_words)
      @hidden_word = mask_secret_word
    end

    def choose_random_word(word_array)
      random_num = rand(word_array.length)
      word_array[random_num].chomp
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