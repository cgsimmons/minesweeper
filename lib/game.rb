# game.rb

require_relative './game_board'

# Class for main game functions
class Game
  attr_accessor :finished, :victory, :game_board, :error

  def initialize
    @finished, @vicotry, @error = false
    system('clear') || system('cls')
    puts 'Welcome to Minesweeper!'
    setup = prompt_game_board
    @game_board = GameBoard.new(setup)
  end

  def game_instructions
    @game_board.print_board(finished?)
    if @error
      puts 'Invalid input!'
      @error = false
    end
    puts 'Options are: -f (flag), -rf (remove flag), or blank to uncover cell.'
    # puts 'Enter "q" to quit at any time.'
    print 'Enter <row> <column> <option>: '
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
    if @game_board.valid?(x, y)
      process_move(x, y, option)
    else
      @error = true
    end
  end

  def process_move(x, y, option)
    case option
    when '-f'
      @game_board.flag(x, y)
    when '-rf'
      @game_board.unflag(x, y)
    else
      @finished = @game_board.bomb?(x, y)
      @game_board.propagate(x, y) unless @finished
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

  def prompt_game_board
    puts 'Create your game area.'
    setup = {}
    setup[:cols] = prompt_cols while setup[:cols].nil?
    setup[:rows] = prompt_rows while setup[:rows].nil?
    while setup[:mines_num].nil?
      setup[:mines_num] = prompt_mines_num((setup[:rows] * setup[:cols] - 1))
    end
    setup
  end

  def prompt_mines_num(max)
    puts "Enter the number of mines (1 - #{max})"
    input = gets.chomp.to_i
    if input <= 0 || input > max
      puts 'Invalid input.'
      nil
    else
      input
    end
  end

  def prompt_rows
    puts 'Enter height (1 - 20)'
    input = gets.chomp.to_i
    if input <= 0 || input > 20
      puts 'Invalid input.'
      nil
    else
      input
    end
  end

  def prompt_cols
    puts 'Enter width (1 - 20)'
    input = gets.chomp.to_i
    if input <= 0 || input > 20
      puts 'Invalid input.'
      nil
    else
      input
    end
  end
end
