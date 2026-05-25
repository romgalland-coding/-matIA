class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :title
      t.string :platform
      t.string :genre
      t.text :description
      t.string :studio
      t.integer :sales
      t.date :release_date
      t.string :collection_status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
