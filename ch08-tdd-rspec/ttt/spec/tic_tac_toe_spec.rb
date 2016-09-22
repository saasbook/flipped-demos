require './tic_tac_toe.rb'
require 'byebug'

describe TicTacToe do
  describe 'new game' do
    it 'starts with correct player'
    it 'raises IllegalMoveError if move to an occupied square' 
  end
  describe 'taking turns' do
    it 'changes to x if o just moved' 
    it 'changes to o if x just moved' 
  end
  describe 'end of game' do
    it 'when no winner, indicates board full' 
    it 'when no winner, indicates no win for x'
    it 'when no winner, indicates no win for o'
    it 'when x wins, indicates win for x'
    it 'when o wins, indicates win for o'
  end
end




