require_relative 'game'
require 'yaml'

def save_game(current_game)
  filename = lint_filename
  return false unless filename

  dump = YAML.dump(current_game)
  File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }
  break
end

def lint_filename
  begin
    filenames = Dir.pwd['/saved']
    puts 'What do you want to name your save file?'
    filename = gets.chomp
    raise "#{filename} already exists!" if filenames.include?(filename)

    filename
  rescue StandardError => e
    puts 'Are you sure you want to rewrite this file? (Y/N)'
    prompt = gets.chomp.downcase
    until ['y', 'n'].include?(prompt)
      puts 'Not one of the options, type "y" or "n"'
      prompt = gets.chomp
    end
  end

  prompt == 'y' ? filename : nil
end

def load_game
  filename = choose_game
  saved_file = File.open(File.join(Dir.pwd, filename), 'r')
  loaded_game = YAML.safe_load(saved_file)
  saved_file.close
  loaded_game
end

def choose_game
  filenames = Dir.pwd['/saved']
  puts 'Choose your file:'
  filenames.each_with_index { |v, i| puts "#{i+1} #{v}" }
  file_choice = gets.chomp

  until filenames.include?(file_choice)
    puts 'That was not one of the saved files. Pick again.'
    file_choice = gets.chomp
  end
  file_choice
end

puts "Let's play some old fashioned Hangman."
puts 'Would you like to: 1) Start a New Game'
puts '                   2) Load a Saved Game'
load_or_new = gets.chomp
until ['1', '2'].include?(load_or_new)
  puts 'Not an option, type 1 or 2'
  load_or_new = gets.chomp
end

word_choices = File.readlines('google-10000-english-no-swears.txt', chomp: true)
load_or_new == '1' ? load_game : Game.new(word_choices, Player.new).play
