class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = current_user.games.find(params[:id])
  end
end
