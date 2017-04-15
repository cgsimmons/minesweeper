# game_board.rb
require 'set'
require_relative './block'

# Class to maintain the gameBoard
class GameBoard
  attr_accessor :rows, :cols, :mines_num, :board

  def initialize(specs = nil)
    if specs.nil?
      prompt_game_board
    else
      @rows = specs[:rows]
      @cols = specs[:cols]
      @mines_num = specs[:mines_num]
    end
    create_board
  end

  def create_board
    randoms = rand_n_array
    block_num = 0
    @board = Array.new(@rows) do |x|
      Array.new(@cols) do |y|
        bomb = randoms.include?(block_num) ? true : false
        block_num += 1
        Block.new({ x: x, y: y }, bomb)
      end
    end
    update_bombs
  end

  def update_bombs
    @board.each do |row|
      row.each do |cell|
        cell.adj_bombs = update_bomb(cell.position)
      end
    end
  end

  def update_bomb(position)
    count = 0
    ((position.x - 1)..(position.x + 1)).each do |x|
      ((position.y - 1)..(position.y + 1)).each do |y|
        count += 1 if valid_position?(x, y, position) &&
                      @board[x][y].bomb?
      end
    end
    count
  end

  def valid_position?(x, y, pos)
    x >= 0 && x < @rows && y >= 0 && y < @cols && !(y == pos.y && x == pos.x)
  end

  def rand_n_array
    randoms = Set.new
    loop do
      randoms << rand(@rows * @cols)
      return randoms.to_a if randoms.size >= @mines_num
    end
  end

  def print_board(finished = false)
    system('clear') || system('cls')
    print_top_row
    @board.each_with_index do |row, i|
      print_left_col(i)
      row.each do |cell|
        print " #{cell.display(finished)} |"
      end
      puts ''
      print_divider_row
    end
  end

  def print_left_col(i)
    print " #{i + 1}"
    print ' ' if i < 9
    print '|'
  end

  def print_top_row
    print '   '
    (1..@cols).each do |i|
      print "| #{i}"
      print ' ' if i < 10
    end
    puts '|'
    print_divider_row
  end

  def print_divider_row
    print '---' + '+---' * @cols
    puts '+'
  end

  def flag(x, y)
    @board[x - 1][y - 1].flag
  end

  def unflag(x, y)
    @board[x - 1][y - 1].unflag
  end

  def bomb?(x, y)
    @board[x - 1][y - 1].bomb?
  end

  def propagate(x, y)
    tmp_cell = @board[x - 1][y - 1]
    if tmp_cell.adj_bombs > 0
      tmp_cell.uncover
      return
    end
    propagate_loop(tmp_cell)
  end

  def propagate_loop(tmp_cell)
    queue = [tmp_cell]
    until queue.empty?
      cell = queue.pop
      cell.uncover
      check_around(cell.position.x, cell.position.y, queue)
    end
  end

  def check_around(x, y, queue)
    ((x - 1)..(x + 1)).each do |row|
      next if row < 0 || row >= @rows
      ((y - 1)..(y + 1)).each do |col|
        check_cell(row, col, queue)
      end
    end
  end

  def check_cell(row, col, queue)
    return if col < 0 || col >= @cols
    puts "testing #{row} #{col}"
    tmp_cell = @board[row][col]
    return if tmp_cell.uncovered?
    if tmp_cell.adj_bombs.zero?
      queue << tmp_cell
    else
      tmp_cell.uncover
    end
  end

  def valid?(x, y)
    x > 0 && x <= @rows && y > 0 && y <= @cols
  end
end
