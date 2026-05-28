class GamesController < ApplicationController
  def index
    @sort = params[:sort].presence_in(Game::SORT_FIELDS) || "title"
    @direction = params[:direction].presence_in(Game::SORT_DIRECTIONS) || "asc"
    @games = current_user.games.sorted_by(@sort, @direction)
  end

  def update
    @game = current_user.games.find(params[:id])
    @game.update(collection_status: params[:collection_status])
    redirect_back fallback_location: games_path
  end

  def destroy
    @game = current_user.games.find(params[:id])
    @game.destroy
    redirect_to games_path(tab: "owned"), notice: "#{@game.title} removed."
  end

  def show
    @game = current_user.games.find(params[:id])
  end
end
