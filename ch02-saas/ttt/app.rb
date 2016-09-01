require 'sinatra'

class TicTacToe < Sinatra::Base

  get '/' do
    @board ||= Array.new(9)
    erb :board
  end
end
