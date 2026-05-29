class GamesController < ApplicationController
  def index
    @sort = params[:sort].presence_in(Game::SORT_FIELDS) || "title"
    @direction = params[:direction].presence_in(Game::SORT_DIRECTIONS) || "asc"
    @selected_platform = params[:platform]
    @selected_genre = params[:genre]
    @selected_studio = params[:studio]

    library_games = current_user.games.where(collection_status: %w[wishlist played])
    library_platforms = library_games.pluck(:platform).flat_map { |platform| Array(platform) }.compact.uniq

    @platform_options = Array(current_user.devices).select { |device| library_platforms.include?(device) }.uniq
    @genre_options = library_games.distinct.pluck(:genre).compact.sort
    @studio_options = library_games.distinct.pluck(:studio).compact.sort

    @games = library_games
             .filter_by(@selected_platform, @selected_genre, @selected_studio)
             .sorted_by(@sort, @direction)
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
