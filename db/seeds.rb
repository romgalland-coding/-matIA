# =============================================================================
# CLEANING DATABASE
# =============================================================================
puts "Cleaning database to avoid duplicates..."
# L'ordre est important pour respecter les dépendances (dependent: :destroy)
User.destroy_all

puts "--- Starting Database Seeding ---"

# =============================================================================
# 1. CREATING USERS
# =============================================================================
puts "Creating users..."

pixel_knight = User.create!(user_name: "PixelKnight", devices: ["PC", "PS5"], email: "pixel_knight@gmail.com", password: "story53421")
cozy_gamer   = User.create!(user_name: "CozyGamer",   devices: ["Nintendo Switch", "Mobile"], email: "cozy_gamer@gmail.com", password: "uwu53R272375")
cyber_pulse  = User.create!(user_name: "CyberPulse",  devices: ["PC", "Xbox Series X"], email: "cyber_pulse@gmail.com", password: "dfatdz64527")

# =============================================================================
# 2. SCENARIOS (Chats, Messages, and associated Games per User)
# =============================================================================
puts "Creating chats, messages and games dynamic profiles..."

# --- SCENARIO 1: PixelKnight (Hardcore Gamer) ---
chat1 = Chat.create!(title: "Hardcore PS5 Recommendations", user_id: pixel_knight.id)

# L'IA va recommander Hades, on crée donc le jeu directement pour PixelKnight avec le statut 'wishlist'
hades_pk = Game.create!(
  title: "Hades", platform: "PC, PS5, Switch", genre: "Roguelike",
  description: "Defy the god of the dead as you hack and slash out of the Underworld.",
  studio: "Supergiant Games", sales: 6_000_000, release_date: Date.parse("2020-09-17"),
  collection_status: "wishlist", # L'utilisateur l'a accepté en wishlist
  user_id: pixel_knight.id
)

Message.create!(chat_id: chat1.id, role: "user", content: "Hey! I need a masterpiece that offers a real challenge on PS5. Any ideas?", game_id: nil)
Message.create!(chat_id: chat1.id, role: "assistant", content: "You should definitely try Hades. It's a fast-paced roguelike with incredible combat.", game_id: hades_pk.id)


# --- SCENARIO 2: CozyGamer (Relaxing games) ---
chat2 = Chat.create!(title: "Chill games for bedtime", user_id: cozy_gamer.id)

# L'IA a recommandé Stardew Valley, mais l'utilisateur ne l'a pas encore validé (statut 'pending')
stardew_cozy = Game.create!(
  title: "Stardew Valley", platform: "PC, PS5, Switch, Mobile", genre: "Simulation",
  description: "An open-ended country-life RPG. Build the farm of your dreams.",
  studio: "ConcernedApe", sales: 30_000_000, release_date: Date.parse("2016-02-26"),
  collection_status: "pending", # En attente d'une action du user dans l'UI
  user_id: cozy_gamer.id
)

Message.create!(chat_id: chat2.id, role: "user", content: "Hi AI, I want a super relaxing game to play on my Switch before sleeping.", game_id: nil)
Message.create!(chat_id: chat2.id, role: "assistant", content: "I have the perfect match for you: Stardew Valley. It's a beautiful, peaceful farming sim.", game_id: stardew_cozy.id)


# --- SCENARIO 3: CyberPulse (Deep PC RPGs) ---
chat3 = Chat.create!(title: "Next big RPG to sink 100h into", user_id: cyber_pulse.id)

# L'IA a recommandé BG3 et l'utilisateur l'a directement acheté/marqué comme possédé
bg3_cyber = Game.create!(
  title: "Baldur's Gate 3", platform: "PC, PS5, Xbox Series X", genre: "RPG",
  description: "Gather your party and return to the Forgotten Realms.",
  studio: "Larian Studios", sales: 15_000_000, release_date: Date.parse("2023-08-03"),
  collection_status: "owned", # Déjà acheté / possédé !
  user_id: cyber_pulse.id
)

Message.create!(chat_id: chat3.id, role: "user", content: "I'm looking for a massive RPG on PC with incredible writing.", game_id: nil)
Message.create!(chat_id: chat3.id, role: "assistant", content: "Look no further than Baldur's Gate 3. It's the ultimate D&D RPG experience.", game_id: bg3_cyber.id)

# =============================================================================
# FINISHED
# =============================================================================
puts "--- Seed successfully executed with your exact model constraints! 🚀 ---"
