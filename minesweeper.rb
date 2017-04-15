# minesweeper.rb
require 'pry'
require_relative './lib/game'

# Main method to control game life cycle
def main
  # binding.pry
  game = Game.new
  game.next_move until game.finished?
  game.ending
end

main
