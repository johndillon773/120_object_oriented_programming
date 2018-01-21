module Hand
  def show_hand
    puts "#{name}'s hand: #{cards.map(&:to_s).join(' ')} "\
      "for a total of #{total}"
    puts ""
  end

  def total
    total = 0
    cards.each do |card|
      total += card.value
    end

    cards.select { |card| card.rank == 'Ace' }.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def busted?
    total > 21
  end

  def reset
    self.cards = []
  end
end

class Participant
  include Hand

  attr_accessor :cards, :name

  def initialize
    @cards = []
    @name = set_name
  end
end

class Dealer < Participant
  DEALER_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def set_name
    DEALER_NAMES.sample
  end

  def show_initial_hand
    puts "#{name}'s hand: #{cards.first} and ?"
  end

  def hit?
    total < 17
  end
end

class Player < Participant
  def set_name
    name = nil
    loop do
      puts "What is your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, please enter a value."
    end
    name
  end

  def show_initial_hand
    show_hand
  end

  def hit?
    answer = nil
    loop do
      puts "Would you like to hit or stay? (h/s)"
      puts ""
      answer = gets.chomp.downcase
      break if %w[h s].include?(answer)
      puts "Please enter 'h' or 's'"
    end
    answer == 'h'
  end
end

class Deck
  attr_reader :cards

  def initialize
    shuffle_cards
  end

  def shuffle_cards
    @cards = []
    Card::RANKS.each do |rank|
      Card::SUITS.each do |suit|
        @cards << Card.new(rank, suit)
      end
    end
    cards.shuffle!
  end

  def deal(participant)
    participant.cards << cards.pop
  end
end

class Card
  SUITS = ["♤", "♥", "♦", "♧"]
  CARD_VALUES = { '2' => 2,   '3' => 3,     '4' => 4,      '5'    => 5,
                  '6' => 6,   '7' => 7,     '8' => 8,      '9'    => 9,
                  '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10,
                  'A' => 11 }
  RANKS = CARD_VALUES.keys

  attr_reader :rank, :suit, :value

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = CARD_VALUES[rank]
  end

  def to_s
    "#{rank}#{suit}"
  end
end

class TwentyOne
  attr_reader :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    display_welcome_message

    loop do
      deal_cards
      show_initial_cards
      player_turn
      sleep(1)
      dealer_turn unless player.busted?
      show_result
      sleep(1)
      break unless play_again?
      reset
    end

    display_goodbye_message
  end

  private

  def player_turn
    loop do
      if player.hit?
        puts "You chose to hit."
        hit(player)
        sleep(1)
        show_cards
        break if player.busted?
      else
        puts "You chose to stay at #{player.total}."
        break
      end
    end
  end

  def dealer_turn
    loop do
      if dealer.hit?
        puts "Dealer hits."
        hit(dealer)
        sleep(1)
        show_cards
        sleep(1)
        break if dealer.busted?
      else
        puts "Dealer stays at #{dealer.total}."
        break
      end
    end
  end

  def hit(participant)
    deck.deal(participant)
    sleep(1)
  end

  def display_welcome_message
    clear
    puts "Hello #{player.name}! Welcome to Twenty-One!"
    puts ""
    sleep(1)
    puts "You'll be playing againts #{dealer.name}."
    puts ""
    sleep(2)
  end

  def clear
    system "clear"
  end

  def deal_cards
    clear
    display_deal_message
    2.times do
      deck.deal(player)
      deck.deal(dealer)
    end
  end

  def display_deal_message
    puts "Shuffling deck..."
    puts ""
    sleep(1)
    puts "Dealing cards..."
    sleep(1)
  end

  def show_initial_cards
    clear
    dealer.show_initial_hand
    puts ""
    player.show_hand
  end

  def show_cards
    clear
    dealer.show_hand
    puts ""
    player.show_hand
  end

  def result
    if dealer.busted?
      :dealer_busted
    elsif player.busted?
      :player_busted
    elsif dealer.total > player.total
      :dealer_won
    elsif player.total > dealer.total
      :player_won
    else
      :tie
    end
  end

  def show_result
    case result
    when :dealer_busted then puts "Dealer busted! You won!"
    when :player_busted then puts "You busted! Dealer won!"
    when :dealer_won    then puts "Dealer won!"
    when :player_won    then puts "You won!"
    when :tie           then puts "It's a tie!"
    end
  end

  def reset
    player.reset
    dealer.reset
    deck.shuffle_cards
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

  def display_goodbye_message
    puts "Thanks for playing Twenty-One! Goodbye."
  end
end

game = TwentyOne.new
game.start
