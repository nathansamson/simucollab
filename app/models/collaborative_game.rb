class CollaborativeGame < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :minimum => 5
  validates_presence_of :description
  validates_length_of :description, :minimum => 10
  validates_presence_of :coordinator
  
  belongs_to :coordinator, :class_name => "User", :foreign_key => "user_id"
  has_and_belongs_to_many :participants, :class_name => "User", :join_table => "game_participants",
                          :insert_sql => 'INSERT INTO game_participants (collaborative_game_id, user_id) VALUES (#{id}, #{record.id})',
                          :order => "name ASC"
end
