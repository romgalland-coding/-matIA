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

    if @game.rawg_id.present? && @game.genre.present?
      rawg = RawgService.new
      results = rawg.by_genre(@game.genre, exclude_rawg_id: @game.rawg_id, devices: current_user.devices) || []

      @similar_games = results.filter_map do |api_game|
        game = current_user.games.find_or_initialize_by(title: api_game["name"])
        game.assign_attributes(
          rawg_id:           api_game["id"],
          genre:             api_game.dig("genres", 0, "name"),
          cover_image:       api_game["background_image"],
          metacritic:        api_game["metacritic"],
          collection_status: game.collection_status.presence || "pending"
        )
        game.save && !%w[played wishlist skipped].include?(game.collection_status) ? game : nil
      end.first(2)
    else
      @similar_games = []
    end
  end
end
