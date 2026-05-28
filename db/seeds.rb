puts "Cleaning database..."
Message.destroy_all
Chat.destroy_all
Game.destroy_all
User.destroy_all

puts "Creating users..."

pixel_knight = User.create!(
  user_name: "PixelKnight",
  devices:   ["PC", "PlayStation 5"],
  email:     "pixel_knight@gmail.com",
  password:  "story53421"
)

cozy_gamer = User.create!(
  user_name: "CozyGamer",
  devices:   ["Nintendo Switch", "iOS", "Android"],
  email:     "cozy_gamer@gmail.com",
  password:  "uwu53R272375"
)

cyber_pulse = User.create!(
  user_name: "CyberPulse",
  devices:   ["PC", "Xbox Series S/X"],
  email:     "cyber_pulse@gmail.com",
  password:  "dfatdz64527"
)

# ---------------------------------------------------------------------------
# Game lists per user  — title + collection_status
# ---------------------------------------------------------------------------

PIXEL_KNIGHT_GAMES = [
  { title: "Elden Ring",                    status: "played"    },
  { title: "Hades",                         status: "played"    },
  { title: "Dead Cells",                    status: "wishlist" },
  { title: "Hollow Knight",                 status: "wishlist" },
  { title: "Celeste",                       status: "played"    },
  { title: "Cuphead",                       status: "pending"  },
  { title: "Cult of the Lamb",              status: "wishlist" },
  { title: "Disco Elysium",                 status: "pending"  },
  { title: "Ori and the Will of the Wisps", status: "wishlist" },
  { title: "Returnal",                      status: "skipped"  }
].freeze

COZY_GAMER_GAMES = [
  { title: "Animal Crossing New Horizons",  status: "played"    },
  { title: "Stardew Valley",                status: "played"    },
  { title: "Kirby and the Forgotten Land",  status: "wishlist" },
  { title: "Unpacking",                     status: "played"    },
  { title: "A Short Hike",                  status: "wishlist" },
  { title: "Spiritfarer",                   status: "pending"  },
  { title: "Coffee Talk",                   status: "wishlist" },
  { title: "Cozy Grove",                    status: "wishlist" },
  { title: "Dorfromantik",                  status: "skipped"  },
  { title: "Mineko's Night Market",         status: "pending"  }
].freeze

CYBER_PULSE_GAMES = [
  { title: "Cyberpunk 2077",                status: "played"    },
  { title: "Red Dead Redemption 2",         status: "played"    },
  { title: "Baldur's Gate 3",               status: "played"    },
  { title: "The Witcher 3 Wild Hunt",       status: "wishlist" },
  { title: "Starfield",                     status: "pending"  },
  { title: "Halo Infinite",                 status: "wishlist" },
  { title: "Forza Horizon 5",               status: "played"    },
  { title: "Control",                       status: "skipped"  },
  { title: "Doom Eternal",                  status: "wishlist" },
  { title: "Assassin's Creed Odyssey",      status: "pending"  }
].freeze

# ---------------------------------------------------------------------------
# Seed helper — fetch from RAWG and create game for a given user
# ---------------------------------------------------------------------------

def seed_game(user:, title:, status:)
  rawg = RawgService.new
  results = rawg.search(title)

  if results.blank?
    puts "  ⚠️  No RAWG result for '#{title}' — skipping"
    return
  end

  api_game   = results.first
  api_detail = rawg.find(api_game["id"])

  platforms  = api_game["platforms"]&.map { |p| p.dig("platform", "name") }&.compact || []
  studio     = api_detail["developers"]&.map { |d| d["name"] }&.join(", ").presence
  metacritic = api_game["metacritic"]

  game = user.games.find_or_initialize_by(title: api_game["name"])
  game.assign_attributes(
    genre:              api_game.dig("genres", 0, "name"),
    platform:           platforms,
    studio:             studio,
    metacritic:         metacritic,
    description:        api_detail["description_raw"].presence,
    cover_image:        api_game["background_image"],
    release_date:       api_game["released"],
    collection_status:  status
  )
  game.save!
  puts "  ✅  #{game.title} (#{status})"
rescue => e
  puts "  ❌  #{title} — #{e.message}"
end

# ---------------------------------------------------------------------------
# Seeding
# ---------------------------------------------------------------------------

puts "\nSeeding PixelKnight's games..."
PIXEL_KNIGHT_GAMES.each { |g| seed_game(user: pixel_knight, title: g[:title], status: g[:status]) }

puts "\nSeeding CozyGamer's games..."
COZY_GAMER_GAMES.each { |g| seed_game(user: cozy_gamer, title: g[:title], status: g[:status]) }

puts "\nSeeding CyberPulse's games..."
CYBER_PULSE_GAMES.each { |g| seed_game(user: cyber_pulse, title: g[:title], status: g[:status]) }

puts "\n--- Seed successfully executed! 🚀 ---"
puts "Users: #{User.count} | Games: #{Game.count}"
