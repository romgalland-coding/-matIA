class SearchGameTool < RubyLLM::Tool
  description "Searches for a real video game by title using the RAWG database and saves it to the user's collection as a pending recommendation."
  param :title, desc: "The exact title of the game to search for"

  def initialize(user:)
    @user = user
    @found_game = nil
  end

  attr_reader :found_game

  def execute(title:)
    rawg = RawgService.new
    results = rawg.search(title)
    return { error: "No game found for '#{title}'" } if results.blank?

    api_game = results.first
    api_detail = rawg.find(api_game["id"])

    platforms = api_game["platforms"]&.map { |p| p.dig("platform", "name") }&.compact || []
    studio    = api_detail["developers"]&.map { |d| d["name"] }&.join(", ").presence

    game = @user.games.find_or_initialize_by(title: api_game["name"])
    game.assign_attributes(
      genre:              api_game.dig("genres", 0, "name"),
      platform:           platforms,
      studio:             studio,
      description:        api_detail["description_raw"].presence,
      cover_image:        api_game["background_image"],
      release_date:       api_game["released"],
      collection_status:  game.collection_status.presence || "pending"
    )
    game.save
    @found_game = game

    {
      title:        game.title,
      genre:        game.genre,
      platforms:    platforms,
      studio:       game.studio,
      release_date: game.release_date&.to_s,
      cover_image:  game.cover_image
    }
  rescue => e
    { error: e.message }
  end
end
