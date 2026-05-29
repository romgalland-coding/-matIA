class AddRawgIdToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :rawg_id, :integer
  end
end
