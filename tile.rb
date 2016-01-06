class Tile
  DELTAS = [
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1],
    [-1, 0],
    [-1, 1]
  ]

  attr_reader :pos

  def initialize(board, pos)
    @board, @pos = board, pos
    @bombed, @explored, @flagged = false
  end

  def bombed?
    @bombed
  end

  def flagged?
    @flagged
  end

  def explored?
    @explored
  end

  def toggle_flag
    # Ignore if already explored
    @flagged = !@flagged unless @explored
  end

  def plant_bomb
    @bombed = true
  end

  def render
    # For visualizing the tile
    if flagged?
      "F"
    elsif explored?
      nbc = neighbor_bomb_count
      nbc == 0 ? " " : nbc.to_s
    else
      "*"
    end
  end

  def reveal
    # For the last visual render
    if flagged?
      # Differentiate correctly maked tiles
      bombed? ? "F" : "f"
    elsif bombed?
      explored? ? "X" : "B"
    else
      nbc = neighbor_bomb_count
      nbc == 0 ? " " : nbc.to_s
    end
  end

  def explore
    # Ignore if tile is flagged or previously explored
    return self if flagged? || explored?

    @explored = true

    if !bombed? && neighbor_bomb_count == 0
      neighbors.each { |neighbor| neighbor.explore }
    end

    self
  end

  def neighbors
    # Returns all of the tile's neighboring tiles (upto 8 if in range)
    valid_positions = DELTAS.select do |delta|
      @board.in_range?([pos[0] + delta[0], pos[1] + delta[1]])
    end

    valid_positions.map { |valid_position| @board[valid_position] }
  end

  def neighbor_bomb_count
    neighbors.select(&:bombed?).count
  end
end
