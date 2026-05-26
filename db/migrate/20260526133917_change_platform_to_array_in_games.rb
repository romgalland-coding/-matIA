class ChangePlatformToArrayInGames < ActiveRecord::Migration[8.1]
  def up
    remove_column :games, :platform
    add_column :games, :platform, :string, array: true, default: []
  end

  def down
    remove_column :games, :platform
    add_column :games, :platform, :string
  end
end
