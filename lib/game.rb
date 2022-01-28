class Game
  def initialize
    @number_of_rounds = 12
    #@answer = CSV File.sample if word is between 5 and 12 characters long
    #@working_answer = @answer.length of "_"
  end

  def play
    loop do
      player.guess_sequence

      if player.has_won?
        puts "#{player.name} guessed the sequence! Great job!"
        puts "#{answer}"
        break
      elsif player.has_lost?
        puts 'Ahhhh you ran out of turns. Beter luck next time.'
        break
      else
        @number_of_rounds -= 1
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
    @guesses = ""
  end

  def guess_sequence
    puts "#{player.name}, what is your guess?"
    @guesses += gets.chomp
  end

  def has_won?
    player.guesses == @answer
  end

  def has_lost?
    game.number_of_rounds == 0
  end
end

player = Player.new

Game.new(player)
