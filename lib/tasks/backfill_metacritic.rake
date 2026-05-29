namespace :games do
  desc "Backfill metacritic score from RAWG for games that don't have one"
  task backfill_metacritic: :environment do
    rawg = RawgService.new
    games = Game.where(metacritic: nil).where.not(rawg_id: nil)

    puts "Backfilling metacritic for #{games.count} games with a rawg_id..."

    games.each do |game|
      api_game = rawg.find(game.rawg_id)
      score = api_game["metacritic"]

      if score.nil?
        puts "  – #{game.title}: no metacritic score on RAWG"
        next
      end

      game.update(metacritic: score)
      puts "  ✓ #{game.title}: #{score}"
    end

    # Games without rawg_id fall back to a title search
    fallback_games = Game.where(metacritic: nil, rawg_id: nil)
    if fallback_games.any?
      puts "\nFallback: searching by title for #{fallback_games.count} games without rawg_id..."

      fallback_games.each do |game|
        results = rawg.search(game.title)
        if results.blank?
          puts "  ✗ #{game.title}: not found"
          next
        end

        score = results.first["metacritic"]
        if score.nil?
          puts "  – #{game.title}: no metacritic score on RAWG"
          next
        end

        game.update(metacritic: score)
        puts "  ✓ #{game.title}: #{score}"
      end
    end

    puts "\nDone."
  end
end
