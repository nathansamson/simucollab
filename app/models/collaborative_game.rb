class CollaborativeGame < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :coordinator
  
  belongs_to :coordinator, :class_name => "User", :foreign_key => "user_id"
end
