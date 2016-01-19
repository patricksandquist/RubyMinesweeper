require 'yaml'
require_relative "board.rb"

class Game
  LAYOUTS = {
    :small => { :grid_size => 9, :num_bombs => 10 },
    :medium => { :grid_size => 16, :num_bombs => 40 },
    :large => { :grid_size => 32, :num_bombs => 160 }
  }

  def initialize(size)
    layout = LAYOUTS[size]
    @board = Board.new(layout[:grid_size], layout[:num_bombs])
  end

  def play
    until @board.won? || @board.lost?
      puts @board.render

      action, pos = get_move
      perform_move(action, pos)
    end

    if @board.won?
      puts "You won!"
    elsif @board.lost?
      puts "You lost!"
      puts @board.reveal
    end
  end

  def get_move
    puts "[e]xplore / [f]lag / [s]ave, row number, column number?"
    action, row_s, col_s = gets.chomp.split(",")

    [action, [row_s.to_i, col_s.to_i]]
  end

  def perform_move(action, pos)
    return unless @board.in_range?(pos)
    tile = @board[pos]

    case action
    when "e"
      tile. explore
    when "f"
      tile.toggle_flag
    when "s"
      save_game
    else
      puts "Not a valid action!"
    end
  end

  def save_game
    puts "Enter filename to save game to."
    filename = gets.chomp

    File.write(filename, YAML.dump(self))
  end
end

if $PROGRAM_NAME == __FILE__
  # running as script

  case ARGV.count
  when 0
    Game.new(:small).play
  when 1
    # resume game, using first argument
    YAML.load_file(ARGV.shift).play
  end
end
