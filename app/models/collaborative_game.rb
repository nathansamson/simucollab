class CollaborativeGame < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :user
  
  belongs_to :user
end
