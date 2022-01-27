


class Game

  def initialize (player)
    @player_name = player_name
    @number_of_rounds = 12
    #@answer = CSV File.sample if word is between 5 and 12 characters long
    #@working_answer = @answer.length of "_"
  end

  def play
    @player.guess_sequence

    if player.has_won?
      #end game
    elsif player.has_lost?
      #end game
    else
      @number_of_rounds -= 1
    end
  end
end

class Player

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