# rps_bonus_features_1.rb

# includes score keeping, lizard & spock, & history of moves

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.paper? || other_move.spock?)) ||
      (spock? && (other_move.rock? || other_move.scissors?))
  end

  def <(other_move)
    (rock? && (other_move.paper? || other_move.spock?)) ||
      (paper? && (other_move.scissors? || other_move.lizard?)) ||
      (scissors? && (other_move.rock? || other_move.spock?)) ||
      (lizard? && (other_move.rock? || other_move.scissors?)) ||
      (spock? && (other_move.paper? || other_move.lizard?))
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or spock:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @history = []
    @games_played = 0
  end

  def display_welcome_message
    system("clear")
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "First to ten games wins!"
    puts "------------------------"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!"
  end

  def display_moves
    system("clear")
    puts "#{human.name} chose #{human.move}"
    sleep(1)
    puts "#{computer.name} chose #{computer.move}"
    sleep(1)
  end

  def winner?
    human.move > computer.move || computer.move > human.move
  end

  def winner
    if human.move > computer.move
      human.name
    elsif human.move < computer.move
      computer.name
    else
      "tie"
    end
  end

  def display_winner
    if winner?
      puts "#{winner} won!"
    else
      puts "It's a tie!"
    end
    sleep(1)
  end

  def increment_score
    if winner == human.name
      human.score += 1
    elsif winner == computer.name
      computer.score += 1
    end
  end

  def display_score
    system("clear")
    puts "Score:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    puts "=============="
  end

  def grand_winner?
    human.score == 10 || computer.score == 10
  end

  def display_grand_winner
    if human.score == 10
      puts "#{human.name} is the grand winner!"
    else
      puts "#{computer.name} is the grand winner!"
    end
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def record_move
    @games_played += 1
    @history << { game: @games_played, 
                  human_move: human.move, 
                  computer_move: computer.move,
                  winner: winner }
  end

  def see_history?
    answer = nil
    loop do
      puts "Would you like to see a history of all moves played? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def display_history
    system("clear")
    headings = " Game ".center(9) +
         "#{human.name}".center(12) +
         "#{computer.name}".center(12) +
         "Winner".center(12)
    puts headings
    puts "#{'-' * (headings.length)}"
    @history.each do |move_hash|
      puts " #{move_hash[:game]} ".center(9) +
           "#{move_hash[:human_move]}".center(12) +
           "#{move_hash[:computer_move]}".center(12) +
           "#{move_hash[:winner]}".center(12)
    end
    puts "#{'-' * (headings.length)}"
  end

  def play
    display_welcome_message

    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        increment_score
        display_score
        record_move
        break if grand_winner?
      end
      display_grand_winner
      break unless play_again?
      reset_score
    end
    display_history if see_history?
    display_goodbye_message
  end
end

RPSGame.new.play
