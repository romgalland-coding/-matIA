class RenameOwnedToPlayedInGames < ActiveRecord::Migration[8.0]
  def up
    Game.where(collection_status: "owned").update_all(collection_status: "played")
  end

  def down
    Game.where(collection_status: "played").update_all(collection_status: "owned")
  end
end
