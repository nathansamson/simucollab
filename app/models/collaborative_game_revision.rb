class CollaborativeGameRevision < ActiveRecord::Base
  belongs_to :user, :foreign_key => "user_id"
  belongs_to :game, :class_name => "CollaborativeGame", :foreign_key => "collaborative_game_id"
end
