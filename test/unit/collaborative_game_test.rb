require 'test_helper'

class CollaborativeGameTest < ActiveSupport::TestCase
  
  def test_new_game
    game = CollaborativeGame.new
    game.name = "Some name"
    game.description = "Some long long description"
    game.coordinator = User.first(:conditions => { :email => "anemail@email.com" })

    assert game.save
  end
  
  def test_new_game_without_coordinator
    game = CollaborativeGame.new
    game.name = "Should not save without coordinator"
    game.description = "Some long long description"
    
    assert !game.save
  end
  
  def test_new_game_with_too_short_name
    game = CollaborativeGame.new
    game.name = "Some"
    game.description = "Some long long description"
    game.coordinator = User.first(:conditions => { :email => "anemail@email.com" })
    
    assert !game.save
  end
  
  def test_new_game_with_too_short_description
    game = CollaborativeGame.new
    game.name = "Some name"
    game.description = "Short des" # < 10 chars
    game.coordinator = User.first(:conditions => { :email => "anemail@email.com" })
    
    assert !game.save
  end
  
  def test_game_joining
    user1 = User.first(:conditions => { :email => "anemail@email.com" })
    user2 = User.first(:conditions => { :email => "anotheremail@email.com" })
  
    game = CollaborativeGame.first
    assert_equal 0, game.participants.size
    
    game.participants << user1
    assert_equal 1, game.participants.size
    
    game.participants << user2
    assert_equal 2, game.participants.size
    
    anothergame = CollaborativeGame.last
    
    anothergame.participants << user2
    assert_equal 1, anothergame.participants.size
    
    anothergame.participants << user1
    assert_equal 2, anothergame.participants.size
  end
end
