class AddParticipantsToGame < ActiveRecord::Migration
  def self.up
    create_table :game_participants do |t|
      t.integer :collaborative_game_id
      t.integer :user_id
    end 
  end

  def self.down
    drop_table :game_participants
  end
end
