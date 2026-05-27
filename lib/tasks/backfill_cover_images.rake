namespace :games do
  desc "Backfill cover_image from RAWG for games that don't have one"
  task backfill_cover_images: :environment do
    rawg = RawgService.new
    games = Game.where(cover_image: nil)

    puts "Backfilling #{games.count} games..."

    games.each do |game|
      results = rawg.search(game.title)
      if results.blank?
        puts "  ✗ No RAWG result for: #{game.title}"
        next
      end

      api_game = results.first
      game.update(cover_image: api_game["background_image"])
      puts "  ✓ #{game.title}"
    end

    puts "Done."
  end
end
