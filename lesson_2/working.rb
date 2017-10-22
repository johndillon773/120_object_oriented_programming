def beat(move)
  case move
  when 'rock'     then %w(paper spock).sample
  when 'paper'    then %w(scissors lizard).sample
  when 'scissors' then %w(rock spock).sample
  when 'lizard'   then %w(rock scissors).sample
  when 'spock'    then %w(paper lizard).sample
  end
end

def beat_most_frequent_move
  all_human_moves = LOG.map { |move| move[:human_move] }
  most_frequent_move = all_human_moves.max_by { |move| all_human_moves.count(move) }
  beat(most_frequent_move)
end

LOG = [ { human_move: 'spock' }, { human_move: 'paper' }, { human_move: 'paper' },
        { human_move: 'spock' }, { human_move: 'paper' }, { human_move: 'paper' },
        { human_move: 'paper' }, { human_move: 'paper' }, { human_move: 'rock' }, { human_move: 'rock' } ]

p beat_most_frequent_move