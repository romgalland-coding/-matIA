puts "Cleaning database to avoid duplicates..."
User.destroy_all
Chat.destroy_all
Message.destroy_all

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
  title: "Dead Cells", platform: ["PC", "PlayStation 4", "Nintendo Switch", "Xbox One"], genre: "Roguelike",
  description: "A roguelite metroidvania where you explore an ever-changing castle, assuming you're able to fight your way past its keepers.",
  studio: "Motion Twin", sales: 10_000_000, release_date: Date.parse("2018-08-07"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Stardew Valley", platform: ["PC", "PlayStation 4", "Nintendo Switch", "Xbox One", "Mobile"], genre: "Farming Sim",
  description: "Inherit your grandfather's old farm plot and learn to live off the land in this open-ended country-life RPG.",
  studio: "ConcernedApe", sales: 41_000_000, release_date: Date.parse("2016-02-26"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Celeste", platform: ["PC", "PlayStation 4", "Nintendo Switch", "Xbox One"], genre: "Platformer",
  description: "Help Madeline survive her journey to the top of Celeste Mountain in this super-tight platformer about facing your inner demons.",
  studio: "Maddy Makes Games", sales: 1_000_000, release_date: Date.parse("2018-01-25"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Cuphead", platform: ["PC", "PlayStation 4", "Nintendo Switch", "Xbox One"], genre: "Run and Gun",
  description: "A classic run and gun action game featuring traditional hand-drawn animation and inspired by the cartoons of the 1930s.",
  studio: "Studio MDHR", sales: 8_000_000, release_date: Date.parse("2017-09-29"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Undertale", platform: ["PC", "PlayStation 4", "Nintendo Switch", "Xbox One"], genre: "RPG",
  description: "A small RPG where every monster can be befriended, every battle solved without violence, and your choices truly matter.",
  studio: "Toby Fox", sales: 5_000_000, release_date: Date.parse("2015-09-15"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Cult of the Lamb", platform: ["PC", "PlayStation 5", "Nintendo Switch", "Xbox Series S/X"], genre: "Roguelike",
  description: "Build a loyal following of woodland worshippers and spread your Word to become the one true cult.",
  studio: "Massive Monster", sales: 3_500_000, release_date: Date.parse("2022-08-11"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Slay the Spire", platform: ["PC", "PlayStation 4", "Nintendo Switch", "Xbox One", "Mobile"], genre: "Deck-Building Roguelike",
  description: "Craft a unique deck, encounter bizarre creatures, discover relics of immense power, and Slay the Spire!",
  studio: "Mega Crit Games", sales: 5_000_000, release_date: Date.parse("2019-01-23"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Ori and the Will of the Wisps", platform: ["PC", "Nintendo Switch", "Xbox One", "Xbox Series S/X"], genre: "Metroidvania",
  description: "Embark on an all-new adventure in a vast world filled with new friends and foes that come to life in stunning hand-painted artwork.",
  studio: "Moon Studios", sales: 2_500_000, release_date: Date.parse("2020-03-11"),
  collection_status: "wishlist", user_id: pixel_knight.id
)

Game.create!(
  title: "Disco Elysium", platform: ["PC", "PlayStation 4", "PlayStation 5", "Nintendo Switch", "Xbox One", "Xbox Series S/X"], genre: "RPG",
  description: "A groundbreaking role playing game. You're a detective with a unique skill system at your disposal and a whole city block to carve your path across.",
  studio: "ZA/UM", sales: 1_500_000, release_date: Date.parse("2019-10-15"),
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
