class CollaborativeGame < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :coordinator
  
  belongs_to :coordinator, :class_name => "User", :foreign_key => "user_id"
  has_and_belongs_to_many :participants, :class_name => "User", :uniq => true, :join_table => "game_participants"
end
