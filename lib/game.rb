require 'pry'

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
      if choice.length >= 5 && choice.length <= 12
        return choice.split(//)
      end
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
    @player.guesses == @answer
  end

  def lost?
    @number_of_rounds == 1
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
    puts "Your working answer is: #{@working_answer.join(' ')}"
    puts "You have #{@number_of_rounds} guess(es) left"
  end

  def play
    until won? || lost?
      @player.guess_sequence
      check_guesses
      next_round
    end
    won? ? won_sequence : lost_sequence
  end
end

class Player
  attr_reader :name
  attr_accessor :guesses

  def initialize
    puts 'What is your name?'
    @name = gets.chomp
    @guesses = ''
  end

  def guess_sequence
    puts "#{@name}, what is your guess?"
    until @guesses.length == 1
      @guesses = ''
      @guesses += gets.chomp.downcase
    end
  end
end
word_choices = File.readlines('google-10000-english-no-swears.txt', chomp: true)

puts "Let's play some old fashioned Hangman."
puts 'Rules are: You can only guess 1 letter at a time.'
human = Player.new
Game.new(word_choices, human).play
