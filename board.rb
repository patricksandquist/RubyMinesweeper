require_relative "tile.rb"

class Board
  attr_reader :grid_size, :num_bombs

  def initialize(grid_size, num_bombs)
    @grid_size, @num_bombs = grid_size, num_bombs

    generate_board
  end

  def in_range?(pos)
    pos.all? { |el| el >= 0 && el < grid_size }
  end

  def [](pos)
    i, j = pos
    @grid[i][j]
  end

  def lost?
    @grid.any? do |row|
      row.any? do |tile|
        tile.explored? && tile.bombed?
      end
    end
  end

  def won?
    @grid.none? do |row|
      row.none? do |tile|
        tile.bombed? != tile.explored?
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
    @grid = Array.new(grid_size) do |i|
      Array.new(grid_size) { |j| Tile.new(self, [i, j]) }
    end

    plant_bombs
  end

  def plant_bombs
    total_bombs = 0

    while total_bombs < num_bombs
      rand_pos = Array.new(2) { rand(grid_size) }
      tile = @grid[rand_pos]

      next if tile.bombed?

      tile.plant_bomb
      total_bombs += 1
    end

    nil
  end
end
