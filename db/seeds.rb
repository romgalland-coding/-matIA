puts "Cleaning database to avoid duplicates..."
User.destroy_all

puts "--- Starting Database Seeding ---"

puts "Creating users..."

pixel_knight = User.create!(user_name: "PixelKnight", devices: ["PC", "PlayStation 5"], email: "pixel_knight@gmail.com", password: "story53421")
cozy_gamer   = User.create!(user_name: "CozyGamer",   devices: ["Nintendo Switch", "iOS", "Android"], email: "cozy_gamer@gmail.com", password: "uwu53R272375")
cyber_pulse  = User.create!(user_name: "CyberPulse",  devices: ["PC", "Xbox Series S/X"], email: "cyber_pulse@gmail.com", password: "dfatdz64527")

puts "Populating users with games in all 4 statuses..."

Game.create!(
  title: "Elden Ring", platform: ["PC", "PlayStation 5", "Xbox Series S/X"], genre: "Action-RPG",
  description: "A challenging open-world action RPG set in a dark fantasy universe.",
  studio: "FromSoftware", sales: 25_000_000, release_date: Date.parse("2022-02-25"),
  collection_status: "owned", user_id: pixel_knight.id
)

Game.create!(
  title: "Hades", platform: ["PC", "PlayStation 5", "Nintendo Switch", "Xbox Series S/X"], genre: "Roguelike",
  description: "Defy the god of the dead as you hack and slash out of the Underworld.",
  studio: "Supergiant Games", sales: 6_000_000, release_date: Date.parse("2020-09-17"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Hollow Knight", platform: ["PC", "PlayStation 5", "Nintendo Switch", "Xbox Series S/X"], genre: "Metroidvania",
  description: "An epic action adventure through a vast ruined kingdom of insects.",
  studio: "Team Cherry", sales: 3_000_000, release_date: Date.parse("2017-02-24"),
  collection_status: "pending", user_id: pixel_knight.id
)

Game.create!(
  title: "Cyberpunk 2077", platform: ["PC", "PlayStation 5", "Xbox Series S/X"], genre: "Sci-Fi RPG",
  description: "An open-world, action-adventure story set in the megalopolis of Night City.",
  studio: "CD Projekt Red", sales: 25_000_000, release_date: Date.parse("2020-12-10"),
  collection_status: "skipped", user_id: pixel_knight.id
)

Game.create!(
  title: "Animal Crossing: New Horizons", platform: ["Nintendo Switch"], genre: "Simulation",
  description: "Escape to a deserted island and create your own paradise.",
  studio: "Nintendo", sales: 44_000_000, release_date: Date.parse("2020-03-20"),
  collection_status: "owned", user_id: cozy_gamer.id
)

Game.create!(
  title: "Stardew Valley", platform: ["PC", "PlayStation 5", "Nintendo Switch", "iOS", "Android"], genre: "Simulation",
  description: "An open-ended country-life RPG. Build the farm of your dreams.",
  studio: "ConcernedApe", sales: 30_000_000, release_date: Date.parse("2016-02-26"),
  collection_status: "wishlist", user_id: cozy_gamer.id
)

Game.create!(
  title: "Slay the Spire", platform: ["PC", "Nintendo Switch", "iOS", "Android"], genre: "Card Battler",
  description: "A fusion of card games and roguelikes. Craft a unique deck.",
  studio: "Mega Crit Games", sales: 4_500_000, release_date: Date.parse("2019-01-23"),
  collection_status: "pending", user_id: cozy_gamer.id
)

Game.create!(
  title: "Hades", platform: ["PC", "PlayStation 5", "Nintendo Switch", "Xbox Series S/X"], genre: "Roguelike",
  description: "Defy the god of the dead as you hack and slash out of the Underworld.",
  studio: "Supergiant Games", sales: 6_000_000, release_date: Date.parse("2020-09-17"),
  collection_status: "skipped", user_id: cozy_gamer.id
)

Game.create!(
  title: "Baldur's Gate 3", platform: ["PC", "PlayStation 5", "Xbox Series S/X"], genre: "RPG",
  description: "Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal.",
  studio: "Larian Studios", sales: 15_000_000, release_date: Date.parse("2023-08-03"),
  collection_status: "owned", user_id: cyber_pulse.id
)

Game.create!(
  title: "Red Dead Redemption 2", platform: ["PC", "Xbox One", "PlayStation 4"], genre: "Action-Adventure",
  description: "An epic tale of life in America's unforgiving heartland at the dawning of the modern age.",
  studio: "Rockstar Games", sales: 65_000_000, release_date: Date.parse("2018-10-26"),
  collection_status: "wishlist", user_id: cyber_pulse.id
)

Game.create!(
  title: "Cyberpunk 2077", platform: ["PC", "PlayStation 5", "Xbox Series S/X"], genre: "Sci-Fi RPG",
  description: "An open-world, action-adventure story set in the megalopolis of Night City.",
  studio: "CD Projekt Red", sales: 25_000_000, release_date: Date.parse("2020-12-10"),
  collection_status: "pending", user_id: cyber_pulse.id
)

Game.create!(
  title: "Elden Ring", platform: ["PC", "PlayStation 5", "Xbox Series S/X"], genre: "Action-RPG",
  description: "A challenging open-world action RPG set in a dark fantasy universe.",
  studio: "FromSoftware", sales: 25_000_000, release_date: Date.parse("2022-02-25"),
  collection_status: "skipped", user_id: cyber_pulse.id
)

puts "--- Seed successfully executed! 🚀 ---"
