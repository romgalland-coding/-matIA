class AddCoverImageToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :cover_image, :string
  end
end
