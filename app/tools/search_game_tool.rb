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

    api_game = best_match(results, title)
    api_detail = rawg.find(api_game["id"])

    platforms  = api_game["platforms"]&.map { |p| p.dig("platform", "name") }&.compact || []
    studio     = api_detail["developers"]&.map { |d| d["name"] }&.join(", ").presence
    metacritic = api_game["metacritic"]

    game = @user.games.find_or_initialize_by(title: api_game["name"])
    game.assign_attributes(
      genre:              api_game.dig("genres", 0, "name"),
      platform:           platforms,
      studio:             studio,
      metacritic:         metacritic,
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
      release_date: game.release_date&.to_s
    }
  rescue => e
    { error: e.message }
  end

  private

  def best_match(results, title)
    normalized = Game.normalize_title(title).downcase
    results.min_by do |r|
      candidate = Game.normalize_title(r["name"]).downcase
      levenshtein(normalized, candidate)
    end
  end

  def levenshtein(a, b)
    m, n = a.length, b.length
    dp = Array.new(m + 1) { |i| Array.new(n + 1) { |j| i.zero? ? j : j.zero? ? i : 0 } }
    (1..m).each do |i|
      (1..n).each do |j|
        dp[i][j] = a[i-1] == b[j-1] ? dp[i-1][j-1] : 1 + [dp[i-1][j], dp[i][j-1], dp[i-1][j-1]].min
      end
    end
    dp[m][n]
  end
end
