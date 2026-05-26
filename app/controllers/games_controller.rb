class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = current_user.games.find(params[:id])
  end

  def destroy
    @game = current_user.games.find(params[:id])
    @game.destroy
    redirect_to games_path, notice: "#{@game.title} removed from wishlist."
  end
end
