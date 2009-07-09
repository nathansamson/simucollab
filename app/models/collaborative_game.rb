# This file is part of SimuCollab.

# SimuCollab is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# SimuCollab is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with SimuCollab.  If not, see <http://www.gnu.org/licenses/>.

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
  
  has_many :revisions, :class_name => "CollaborativeGameRevision"
  acts_as_authorization_object :role_class_name => 'Coordinator'
  
  def is_open_to_user? user
    if not participants.exists? user then
      return false
    end
    
    if !is_started?
      return false
    end
    
    return current_checkout == nil
  end
  
  def is_started?
    return revisions.size >= 1
  end
  
  def checkout user
    return nil unless is_open_to_user? user
    revision = CollaborativeGameRevision.new
    revision.user = user
    revision.game = self
    revision.reverted = false
    revision.savegame = nil
    revisions << revision
    return revision
  end
  
  def last_checkout
    return revisions.last :conditions => { :reverted => false },  :order => "created_at"
  end 
   
  def current_checkout
    return revisions.last :conditions => { :reverted => false, :savegame => nil },
                          :order => "created_at"
  end
  
  def can_check_in? user
    return current_checkout != nil && current_checkout.user == user
  end
  
  def check_in savegame
    checkout = current_checkout
    checkout.savegame = savegame
    checkout.save
  end
  
  def revert_last_checkout
    if revisions.size == 1
      return
    end
    checkout = last_checkout
    checkout.reverted = true
    checkout.save
    if current_checkout != nil
      checkout = current_checkout
      checkout.reverted = true
      checkout.save
    end
  end
  
  def start_game filename
    revision = CollaborativeGameRevision.new
    revision.user = coordinator
    revision.reverted = false
    revision.savegame = filename
    revisions << revision
  end
    
end
