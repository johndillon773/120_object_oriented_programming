# rps_bonus_features_2.rb

# includes score keeping, lizard & spock, 
# class for each move, history of moves, 
# computer personalities

class Move
  VALUES = %w(rock paper scissors lizard spock)

  attr_reader :move

  def to_s
    @move
  end
end

class Rock < Move
  def initialize
    @move = 'rock'
  end

  def >(other_move)
    other_move.is_a?(Scissors) || other_move.is_a?(Lizard)
  end
end

class Paper < Move
  def initialize
    @move = 'paper'
  end

  def >(other_move)
    other_move.is_a?(Rock) || other_move.is_a?(Spock)
  end
end

class Scissors < Move
  def initialize
    @move = 'scissors'
  end

  def >(other_move)
    other_move.is_a?(Paper) || other_move.is_a?(Lizard)
  end
end

class Lizard < Move
  def initialize
    @move = 'lizard'
  end

  def >(other_move)
    other_move.is_a?(Paper) || other_move.is_a?(Spock)
  end
end

class Spock < Move
  def initialize
    @move = 'spock'
  end

  def >(other_move)
    other_move.is_a?(Rock) || other_move.is_a?(Scissors)
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
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
    select_move(choice)
  end
end

class R2D2 < Player
  def set_name
    self.name = 'R2D2'
  end

  def choose
    select_move('rock')
  end
end

class Hal < Player
  def set_name
    self.name = 'Hal'
  end

  def choose
    choice = %W(#{Move::VALUES[0]}
                #{Move::VALUES[2]}
                #{Move::VALUES[2]}
                #{Move::VALUES[2]}
                #{Move::VALUES[2]}
                #{Move::VALUES[2]}
                #{Move::VALUES[3]}
                #{Move::VALUES[3]}
                #{Move::VALUES[3]}
                #{Move::VALUES[4]}).sample
    select_move(choice)
  end
end

class Chappie < Player
  def set_name
    self.name = 'Chappie'
  end

  def choose
    choice = 'rock'
    select_move(choice)
  end
end

class Sonny < Player
  def set_name
    self.name = 'Sonny'
  end

  def choose
    if @history.empty?
      choice = Move::VALUES.sample
    else
      choice = @history.last[:human_move]
    end
    select_move(choice)
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
    select_move(choice)
  end
end

class History
  attr_reader :move_log

  def initialize
    @move_log = []
  end

  def record_move(human_move, computer_move, winner)
    @move_log << { human_move: human_move, 
                  computer_move: computer_move,
                  winner: winner }
  end

  def display_log(human_name, computer_name)
    system("clear")
    headings = " Game ".center(9) +
         "#{human_name}".center(12) +
         "#{computer_name}".center(12) +
         "Winner".center(12)
    line_break = "#{'-' * (headings.length)}"

    puts headings
    puts line_break
    @move_log.each_with_index do |move_hash, idx|
      puts " #{idx + 1} ".center(9) +
           "#{move_hash[:human_move]}".center(12) +
           "#{move_hash[:computer_move]}".center(12) +
           "#{move_hash[:winner]}".center(12)
    end
    puts line_break
  end
end

class RPSGame
  attr_accessor :human, :computer, :history

  def initialize
    @human = Human.new
    @computer = [R2D2.new, Hal.new, Chappie.new, Sonny.new, Number5.new].sample
    @history = History.new
  end

  def display_welcome_message
    system("clear")
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
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
    history.record_move(human.move, computer.move, winner)
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
    history.display_log(human.name, computer.name) if see_history?
    display_goodbye_message
  end
end

RPSGame.new.play
