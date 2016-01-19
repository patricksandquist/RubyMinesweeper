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

  def bomb?
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
      "_"
    end
  end

  def reveal
    # For the last visual render
    if flagged?
      # Differentiate correctly maked tiles
      bomb? ? "F" : "f"
    elsif bomb?
      explored? ? "*" : "B"
    else
      nbc = neighbor_bomb_count
      nbc == 0 ? " " : nbc.to_s
    end
  end

  def explore
    # Ignore if tile is flagged or previously explored
    return self if flagged? || explored?

    @explored = true

    if !bomb? && neighbor_bomb_count == 0
      neighbors.each { |neighbor| neighbor.explore }
    end

    self
  end

  def neighbors
    # Returns all of the tile's neighboring tiles (upto 8 if in range)
    adjacent_positions = DELTAS.map do |delta|
      [pos[0] + delta[0], pos[1] + delta[1]]
    end

    # Make sure they're in range
    valid_positions = adjacent_positions.select do |adjacent_position|
      @board.in_range?(adjacent_position)
    end

    valid_positions.map { |valid_position| @board[valid_position] }
  end

  def neighbor_bomb_count
    neighbors.select(&:bomb?).count
  end
end
