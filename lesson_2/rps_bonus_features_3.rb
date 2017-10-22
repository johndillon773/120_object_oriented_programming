# rps_bonus_features_2.rb

# includes score keeping, lizard & spock, 
# class for each move, history of moves, 
# computer personalities

require 'pry'

class Move
  VALUES = %w(rock paper scissors lizard spock)

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
  attr_reader :history

  def initialize(history_of_moves)
    @history = history_of_moves
    set_name
    @score = 0
  end

  def select_move(choice)
    self.move = case choice
                when 'rock'     then Rock.new
                when 'paper'    then Paper.new
                when 'scissors' then Scissors.new
                when 'lizard'   then Lizard.new
                when 'spock'    then Spock.new
    end
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break if n.match(/\w/)
      puts "Sorry, must enter at least one alpha-numeric character."
    end
    self.name = n.strip
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

class R2D2 < Player
  def set_name
    self.name = 'R2D2'
  end

  def choose
    self.move = Move.new('rock')
  end
end

class Hal < Player
  def set_name
    self.name = 'Hal'
  end

  def choose
    idx = [2, 2, 2, 2, 2, 2, 3, 3, 3, 4].sample
    self.move = Move.new(Move::VALUES[idx])
  end
end

class Chappie < Player
  def set_name
    self.name = 'Chappie'
  end

  def choose
    choice = @options.shift
    @options << choice
    self.move = Move.new(choice)
  end
end

class Sonny < Player
  def set_name
    self.name = 'Sonny'
  end

  def choose
    if history.log.length < 1
      choice = Move::VALUES.sample
    else
      choice = history.log.last[:human_move]
    end
    self.move = Move.new(choice)
  end
end

class Number5 < Player
  def set_name
    self.name = 'Number 5'
  end

  def choose
    if @history.empty?
      choice = Move::VALUES.sample
    else
      choice = case @history.last[:human_move]
               when 'rock'     then %w(paper, spock).sample
               when 'paper'    then %w(scissors, lizard).sample
               when 'scissors' then %w(rock, spock).sample
               when 'lizard'   then %w(rock, scissors).sample
               when 'spock'    then %w(paper, lizard).sample
               end
    end
    self.move = Move.new(choice)
  end
end

class History
  def initialize
    @moves = []
  end

  def record(move)
    @moves << move
  end

  def display(human_name, computer_name)
    system("clear")
    headings = " Game ".center(9) +
         "#{human_name}".center(12) +
         "#{computer_name}".center(12) +
         "Winner".center(12)
    line_break = "#{'-' * (headings.length)}"

    puts headings
    puts line_break
    @moves.each_with_index do |move_hash, idx|
      puts " #{idx + 1} ".center(9) +
           "#{move_hash[:human_move]}".center(12) +
           "#{move_hash[:computer_move]}".center(12) +
           "#{move_hash[:winner]}".center(12)
    end
    puts line_break
  end
end

class RPSGame
  attr_reader :history
  attr_accessor :human, :computer

  def initialize
    @history = History.new
    @human = Human.new(history)
    @computer = Sonny.new(history)#[R2D2.new, Hal.new, Chappie.new].sample#, Sonny.new, Number5.new].sample
  end

  def display_welcome_message
    system("clear")
    puts "Hi #{human.name}, welcome to Rock, Paper, Scissors, Lizard, Spock!"
    sleep(1)
    puts "You'll be playing against #{computer.name}."
    sleep(1)
    puts "First to five games wins!"
    sleep(1)
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
    elsif computer.move > human.move
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
    human.score == 5 || computer.score == 5
  end

  def display_grand_winner
    if human.score == 5
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
    move = { human_move: human.move,
             computer_move: computer.move,
             winner: winner }
    history.record(move)
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
    history.display(human.name, computer.name) if see_history?
    display_goodbye_message
  end
end

RPSGame.new.play
