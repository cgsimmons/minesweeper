# block.rb

# Class for game board blocks
class Block
  Position = Struct.new(:x, :y)
  State = Struct.new(:uncovered, :flagged, :bomb)
  ADJ_BOMBS_CHAR = [' ', '①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧'].freeze

  attr_accessor :position, :state, :adj_bombs

  def initialize(position = { x: 0, y: 0 },
                 bomb = false,
                 adj_bombs = 0)
    @position = Position.new(position[:x], position[:y])
    @state = State.new(false, false, bomb)
    @adj_bombs = adj_bombs
  end

  # Character to be displayed based on state
  def display(gameOver = false)
    return '✖' if gameOver && @state.bomb
    return ADJ_BOMBS_CHAR[@adj_bombs] if @state.uncovered || gameOver
    return '✔' if @state.flagged
    '■'
  end

  def bomb?
    state.bomb
  end

  def uncovered?
    state.uncovered
  end

  def flagged?
    state.flagged
  end

  def uncover
    state.uncovered = true
  end

  def flag
    state.flagged = true
  end

  def unflag
    state.flagged = false
  end
end
