# frozen_string_literal: true

require 'yaml'

class Game
  attr_reader :answer, :number_of_rounds

  def initialize(choices, human)
    @player = human
    @number_of_rounds = 12
    @answer = pick_answer(choices)
    @working_answer = create_working_answer(@answer)
  end

  def create_working_answer(word)
    return_value = []
    word.length.times { return_value << '_' }
    return_value
  end

  def pick_answer(choices)
    loop do
      choice = choices[rand(10_000)]
      return choice.split(//) if choice.length >= 5 && choice.length <= 12
    end
  end

  def check_guesses
    guess = @player.guesses
    @answer.each_with_index do |letter, index|
      guess == letter ? @working_answer[index] = letter : next
    end
    @player.guesses = ''
  end

  def won?
    @working_answer == @answer
  end

  def lost?
    @number_of_rounds == 0
  end

  def won_sequence
    puts "#{@player.name} guessed the sequence! Great job!"
    puts @answer.join('').to_s
  end

  def lost_sequence
    puts 'Ahhhh you ran out of turns. Beter luck next time.'
    puts "The answer was #{@answer.join('')}!"
  end

  def next_round
    @number_of_rounds -= 1
  end

  def play
    puts "You have #{number_of_rounds} rounds"
    puts "Your current guesses: #{@working_answer.join(' ')}"
    puts "Your previous guesses: #{@player.previous_guesses}"
    puts "#{@player.name}, enter a letter or type 'save' to save your progress"
    player_input = gets.chomp.downcase
    return 'save' if player_input == 'save'

    @player.guess_sequence(player_input)
    check_guesses
    next_round
  end
end

class Player
  attr_reader :name
  attr_accessor :guesses, :previous_guesses

  def initialize
    puts 'What is your name?'
    @name = gets.chomp
    @guesses = ''
    @previous_guesses = ''
  end

  def guess_sequence(input)
    @guesses = input
    until @guesses.length == 1 && /[[:alpha:]]/.match(@guesses)
      @guesses = ''
      puts 'Try again, one letter at a time'
      @guesses += gets.chomp.downcase
    end
    @previous_guesses += @guesses
    @guesses
  end
end

def load_game
  filename = choose_game
  saved_file = File.open(File.join(Dir.pwd, filename), 'r')
  loaded_game = YAML.load(saved_file)
  saved_file.close
  loaded_game
end

def choose_game
  filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
  puts 'Choose your file by typing its name:'
  filenames.each { |v| puts v.to_s }
  file_choice = gets.chomp

  until filenames.include?(file_choice)
    puts 'That was not one of the saved files. Pick again.'
    file_choice = gets.chomp
  end
  puts
  "saved/#{file_choice}.yaml"
end

def save_game(current_game)
  filename = lint_filename
  return false unless filename

  dump = YAML.dump(current_game)
  File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }
end

def lint_filename
  begin
    filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
    puts 'What do you want to name your save file?'
    filename = gets.chomp
    raise "#{filename} already exists!" if filenames.include?(filename)

    filename
  rescue StandardError => e
    puts "#{e} Are you sure you want to rewrite this file? (Y/N)"
    prompt = gets.chomp.downcase
    until ['y', 'n'].include?(prompt)
      puts 'Not one of the options, type "y" or "n"'
      prompt = gets.chomp
    end
    prompt == 'y' ? filename : nil
  end
end

word_choices = File.readlines('google-10000-english-no-swears.txt', chomp: true)

puts "Let's play some old fashioned Hangman."
puts 'Would you like to: 1) Start a New Game'
puts '                   2) Load a Saved Game'
load_or_new = gets.chomp
until ['1', '2'].include?(load_or_new)
  puts 'Not an option, type 1 or 2'
  load_or_new = gets.chomp
end

game = load_or_new == '2' ? load_game : Game.new(word_choices, Player.new)

until game.won? || game.lost?
  if game.play == 'save'
    save_game(game)
    puts 'Game saved!'
    break
  end

  if game.won? then game.won_sequence end
  if game.lost? then game.lost_sequence end
end
