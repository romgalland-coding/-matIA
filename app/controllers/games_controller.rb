class GamesController < ApplicationController
  def index
    @games = current_user.games
  end

  def update
    @game = current_user.games.find(params[:id])
    @game.update(collection_status: params[:collection_status])
    redirect_back fallback_location: games_path
  end

  def destroy
    @game = current_user.games.find(params[:id])
    @game.destroy
    redirect_to games_path, notice: "#{@game.title} removed."
  end

  def show
    @game = current_user.games.find(params[:id])
  end
end
