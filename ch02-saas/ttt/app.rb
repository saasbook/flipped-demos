require 'sinatra'
require 'byebug'
require './tic_tac_toe.rb'

class TicTacToeApp < Sinatra::Base
  enable :sessions

  post '/new' do
    @game = TicTacToe.new
    session[:game] = @game
    redirect '/'
  end

  post '/move/:player' do
    @game = session[:game]
    player = params[:player]
    square = params[:square].to_i
    @game.move(player, square)
    session[:game] = @game
    redirect '/'
  end

  get '/' do
    @game = session[:game]
    # first time here?
    session[:game] = @game = TicTacToe.new unless @game
    erb :game
  end
end
