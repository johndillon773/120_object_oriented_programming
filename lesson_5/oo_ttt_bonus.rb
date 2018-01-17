require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def best_move(marker, opponent_marker)
    square = find_winning_square(marker)

    if !square
      square = find_winning_square(opponent_marker)
    end

    if !square && unmarked_keys.include?(5)
      square = 5
    end

    if !square
      square = unmarked_keys.sample
    end

    square
  end

  def find_winning_square(mark)
    winning_square = nil
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if squares.select(&:unmarked?).count == 1 &&
         squares.select { |square| square.marker == mark }.count == 2
        winning_line = @squares.select do |k, v|
          line.include?(k) && v.unmarked?
        end
        winning_square = winning_line.keys.first
      end
    end
    winning_square
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
  attr_accessor :score, :name, :marker

  def initialize(marker=nil)
    @marker = marker
    @score = 0
    @name = %w[Hal R2D2 Chappie C3PO].sample
  end
end

class TTTGame
  HUMAN_MARKER = :choose
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = :choose

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = nil
  end

  # rubocop:disable Metrics/MethodLength
  def play
    set_name
    display_welcome_message
    choose_game_settings

    loop do
      loop do
        display_board
        players_move
        display_result
        increment_score
        break if grand_winner?
        reset
      end

      display_grand_winner
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end
  # rubocop:enable Metrics/MethodLength

  private

  def players_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def set_name
    player_name = nil
    puts "Please enter your name:"
    loop do
      player_name = gets.chomp
      break if player_name =~ /\w/
      puts "Please enter at least one alphanumeric character."
    end
    human.name = player_name
  end

  def choose_game_settings
    set_player_marker if HUMAN_MARKER == :choose
    set_first_to_move
  end

  def set_player_marker
    marker = nil
    puts "Choose any single letter or number for your marker, except 'O'."
    loop do
      marker = gets.chomp
      break if marker =~ /\w/ && marker.length == 1 && marker != 'O'
      puts "Sorry, you must choose a single letter or number."
    end

    human.marker = marker
  end

  def set_first_to_move
    @current_marker = case FIRST_TO_MOVE
                      when :player then human.marker
                      when :computer then computer.marker
                      when :choose then choose_first_to_move
                      end
  end

  def choose_first_to_move
    first = nil
    puts "Who moves first, player or computer? (p/c)"
    loop do
      first = gets.chomp.downcase
      break if %w[p c].include?(first)
      puts "Sorry, you must choose 'p' or 'c'"
    end

    case first
    when 'p' then human.marker
    when 'c' then computer.marker
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
    human.score >= 5 || computer.score >= 5
  end

  def display_grand_winner
    if human.score >= 5
      puts "#{human.name} is the Grand Winner!"
    else
      puts "Computer is the Grand Winner!"
    end
  end

  def display_welcome_message
    clear
    puts "Hello #{human.name}, welcome to Tic Tac Toe!"
    sleep(1)
    puts "You'll be playing against #{computer.name}."
    sleep(1)
    puts "First to five games wins!"
    sleep(1)
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    clear
    puts "#{human.name} is #{human.marker}, " \
         "#{computer.name} is #{computer.marker}"
    puts ""
    display_score
    puts ""
    board.draw
    puts ""
  end

  def joiner(arr, punctuation=", ", word = "or")
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(punctuation)
    end
  end

  def human_moves
    puts "Choose a square (#{joiner(board.unmarked_keys)}) "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = board.best_move(computer.marker, human.marker)

    board[square] = computer.marker
  end

  def current_player_moves
    if @current_marker == human.marker
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
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
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts "Score:"
    puts "#{human.name}: #{human.score}, #{computer.name}: #{computer.score}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w[y n].include? answer
      puts "Sorry, must be y or n "
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
