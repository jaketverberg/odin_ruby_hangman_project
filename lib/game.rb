class Game
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
      choice = choices.sample
      if choice.length >= 5 && choice.length <= 12
        choice.split(//)
        return choice
      end
    end
  end

  def play
    loop do
      @player.guess_sequence

      if @player.won?
        puts "#{player.name} guessed the sequence! Great job!"
        puts @answer.to_s
        break
      elsif @player.lost?
        puts 'Ahhhh you ran out of turns. Beter luck next time.'
        break
      else
        @number_of_rounds -= 1
        puts @number_of_rounds.to_s
      end
    end
  end
end

class Player
  attr_reader :name
  attr_accessor :guesses

  def initialize
    puts "Let's play some old fashioned Hangman. What is your name?"
    @name = gets.chomp
    @guesses = ''
  end

  def guess_sequence
    puts "#{player.name}, what is your guess?"
    @guesses += gets.chomp
  end

  def won?
    @guesses == @answer
  end

  def lost?
    @number_of_rounds.zero?
  end
end

word_file = File.read('google-10000-english-no-swears.txt')
word_choices = word_file.readlines.map(&:chomp)

human = Player.new

Game.new(word_choices, human)
