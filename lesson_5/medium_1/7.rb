# Number Guesser (Pt 2)

class GuessingGame

  def initialize(begin_range, end_range)
    @guess = nil
    @range = (begin_range..end_range)
    @magic_number = @range.to_a.sample
    @guesses_remaining = Math.log2(@range.size).to_i + 1
  end

  def play
    loop do
      show_guesses_remaining
      get_guess
      give_hint unless player_won?
      break if game_over?
    end
    player_won? ? show_win_message : show_lose_message
  end

  def show_guesses_remaining
    puts "You have #{@guesses_remaining} guesses remaining."
  end

  def get_guess
    loop do
      print "Enter a number between 1 and 100: "
      @guess = gets.chomp.to_i
      break if (1..100).include?(@guess)
      print "Invalid guess. "
    end
    @guesses_remaining -= 1
  end

  def give_hint
    if @guess < @magic_number
      puts "Your guess is too low."
    elsif @guess > @magic_number
      puts "Your guess is too high."
    end
  end

  def game_over?
    player_won? || no_more_guesses?
  end

  def player_won?
    @guess == @magic_number
  end

  def no_more_guesses?
    @guesses_remaining == 0
  end

  def show_win_message
    puts "You win!"
  end

  def show_lose_message
    puts "You are out of guesses. You lose."
  end
end

game = GuessingGame.new(1, 100)
game.play