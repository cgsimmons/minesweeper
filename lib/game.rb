# game.rb

require_relative './game_board'

# Class for main game functions
class Game
  attr_accessor :finished, :victory, :game_board

  def initialize
    @finished, @vicotry = false
    system('clear') || system('cls')
    puts 'Welcome to Minesweeper!'
    @game_board = GameBoard.new
  end

  def game_instructions
    @game_board.print_board(finished?)
    puts 'X is left side, Y is top'
    puts 'Options are; -f (flag), -rf (remove flag)'
    print 'Enter <x> <y> <option>: '
  end

  def finished?
    return true if @finished
    @game_board.board.each do |row|
      row.each do |cell|
        return false if cell.bomb? == false && cell.uncovered? == false
      end
    end
    @victory, @finished = true
  end

  def next_move
    game_instructions
    input = gets.chomp.split(' ')
    x = input[0].to_i
    y = input[1].to_i
    option = input[2]
    process_move(x, y, option)
  end

  def process_move(x, y, option)
    case option
    when '-f'
      @game_board.flag(x, y)
    when '-rf'
      @game_board.unflag(x, y)
    else
      @game_board.uncover(x, y)
      @finished = @game_board.bomb?(x, y)
    end
  end

  def ending
    @game_board.print_board(true)
    if @victory
      puts 'Congratulations!'
    else
      puts 'Nice try.'
    end
  end
end
