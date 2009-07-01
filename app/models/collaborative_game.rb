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
  
  def is_open_to_user? user
    if not participants.exists? user then
      return false
    end
    
    return current_checkout == nil
  end
  
  def checkout user
    return nil unless is_open_to_user? user
    revision = CollaborativeGameRevision.new
    revision.user = user
    revision.game = self
    revision.reverted = false
    revision.savegame = nil
    revision.save
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
  
  def can_check_in
    return current_checkout != nil
  end
  
  def check_in savegame
    checkout = current_checkout
    checkout.savegame = savegame
    checkout.save
  end
  
  def revert_last_checkout
    checkout = last_checkout
    checkout.reverted = true
    checkout.save
  end
    
end
