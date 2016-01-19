require_relative "tile.rb"

class Board
  attr_reader :grid_size, :num_bombs

  def initialize(grid_size, num_bombs)
    @grid_size, @num_bombs = grid_size, num_bombs

    generate_board
  end

  def in_range?(pos)
    pos.all? { |coord| coord >= 0 && coord < grid_size }
  end

  def [](pos)
    i, j = pos
    @grid[i][j]
  end

  def lost?
    @grid.any? do |row|
      row.any? do |tile|
        tile.explored? && tile.bomb?
      end
    end
  end

  def won?
    # All of the free spaces must be explored to win
    @grid.all? do |row|
      row.all? do |tile|
        !tile.bomb? && tile.explored?
      end
    end
  end

  def render(reveal = false)
    @grid.map do |row|
      row.map do |tile|
        reveal ? tile.reveal : tile.render
      end.join("")
    end.join("\n")
  end

  def reveal
    # Force render to reveal all tiles on the board
    render(true)
  end

  private

  def generate_board
    @grid = Array.new(grid_size) do |row|
      Array.new(grid_size) { |col| Tile.new(self, [row, col]) }
    end

    plant_bombs
  end

  def plant_bombs
    total_bombs = 0

    while total_bombs < num_bombs
      rand_pos = Array.new(2) { rand(grid_size) }
      tile = self[rand_pos]

      next if tile.bomb?

      tile.plant_bomb
      total_bombs += 1
    end

    nil
  end
end
