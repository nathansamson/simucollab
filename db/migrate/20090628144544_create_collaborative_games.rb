class CreateCollaborativeGames < ActiveRecord::Migration
  def self.up
    create_table :collaborative_games do |t|
      t.string :name
      t.text :description
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :collaborative_games
  end
end
