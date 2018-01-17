require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def find_at_risk_square(line, marker)
    if @squares.values_at(*line).count(marker) == 2
      @squares.select { |k, v| line.include?(k) && v == Square::INITIAL_MARKER }.keys.first
    else
      nil
    end
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :score
  attr_reader :marker

  def initialize(marker)
    @score = 0
    @marker = marker
  end

  def reset
    @score = 0
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message

    loop do
      loop do
        display_board
  
        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          display_board
        end

        display_result
        increment_score
        break if grand_winner?
        reset_board
      end

      display_board
      display_grand_winner
      break unless play_again?
      display_play_again_message
      reset_board
      reset_score
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    sleep(1)
    puts "First to five games wins!"
    sleep(1)
  end

  def display_goodbye_message
    puts "Thank you for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    clear
    puts "You're an #{human.marker}, computer is an #{computer.marker}"
    puts ""
    display_score
    puts ""
    board.draw
    puts ""
  end

  def joiner(arr, punctuation=', ', word='or')
    case arr.length
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(punctuation)
    end
  end

  def human_moves
    puts "Choose a square (#{joiner(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = nil

    binding.pry

    Board::WINNING_LINES.each do |line|
      square = board.find_at_risk_square(line, COMPUTER_MARKER)
      break if square
    end

    if !square
      Board::WINNING_LINES.each do |line|
        square = board.find_at_risk_square(line, HUMAN_MARKER)
        break if square
      end
    end

    if !square
      square = 5 if board.unmarked_keys.include?(5)
    end

    if !square
      board.unmarked_keys.sample
    end

    board[square] = computer.marker
  end

  def current_player_moves
    if @current_marker == HUMAN_MARKER
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def display_result
    display_board
    display_winner
    sleep(2)
  end

  def display_winner
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts "Score:"
    puts "You: #{human.score}, computer: #{computer.score}"
  end

  def display_grand_winner
    if human.score == 5
      puts "You are the grand winner!"
    elsif computer.score == 5
      puts "Computer is the grand winner!"
    end
  end

  def increment_score
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def grand_winner?
    human.score == 5 || computer.score == 5
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?"
      answer = gets.chomp.downcase
      break if %w[y n].include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset_board
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def reset_score
    human.reset
    computer.reset
  end

  def display_play_again_message
    puts "Let's Play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
