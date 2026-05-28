class AddMetacriticToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :metacritic, :integer
  end
end
