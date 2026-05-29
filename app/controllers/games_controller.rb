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
    enrich_game_if_needed

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

  private

  def enrich_game_if_needed
    return unless @game.rawg_id.present? && @game.description.blank?

    detail = RawgService.new.find(@game.rawg_id)
    return if detail.blank?

    @game.update(
      platform:    detail["platforms"]&.map { |p| p.dig("platform", "name") }&.compact || [],
      studio:      detail["developers"]&.map { |d| d["name"] }&.join(", ").presence,
      description: detail["description_raw"].presence,
      release_date: detail["released"],
      metacritic:  detail["metacritic"]
    )
  end
end
