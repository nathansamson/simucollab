class CreateCollaborativeGameRevisions < ActiveRecord::Migration
  def self.up
    create_table :collaborative_game_revisions do |t|
      t.integer :user_id
      t.integer :collaborative_game_id
      t.boolean :reverted
      t.string :savegame

      t.timestamps
    end
  end

  def self.down
    drop_table :collaborative_game_revisions
  end
end
