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
  
    game = collaborative_games(:agame)
    assert_equal 5, game.participants.size
    
    game.participants << user1
    assert_equal 6, game.participants.size
    
    game.participants << user2
    assert_equal 7, game.participants.size
    
    anothergame = collaborative_games(:secondgame)
    
    anothergame.participants << user2
    assert_equal 1, anothergame.participants.size
    
    anothergame.participants << user1
    assert_equal 2, anothergame.participants.size
  end
  
  def test_checkout
    game = collaborative_games(:agame)
    checkout = game.checkout users(:player1)
    assert_not_equal nil, checkout
    assert_equal game, checkout.game
    assert_equal users(:player1), checkout.user
    
    checkout2 = game.checkout users(:player2)
    assert_equal nil, checkout2
    
    current_checkout = game.current_checkout
    assert_equal checkout, current_checkout
    
    assert game.can_check_in?(users(:player1))
    assert !game.can_check_in?(users(:player2))
    
    game.check_in "somestring.sve"
    current_checkout = game.last_checkout
    
    assert_equal nil, game.current_checkout
    assert_equal false, current_checkout.reverted
    assert_equal "somestring.sve", current_checkout.savegame
    
    assert_equal "somestring.sve", game.last_checkout.savegame
  end
  
  def test_checkout_when_not_in_game
    game = collaborative_games(:agame)
    
    assert !game.is_open_to_user?(users(:auser))
    
    checkout = game.checkout users(:auser)
    assert_equal nil, checkout
  end
  
  def test_checkout_when_checkin_reverted_before_checkin
    game = collaborative_games(:agame)
    checkout = game.checkout users(:player1)
    
    checkout2 = game.checkout users(:player2)
    assert_equal nil, checkout2
    
    game.revert_last_checkout
    
    checkout2 = game.checkout users(:player2)
    assert_equal users(:player2), checkout2.user
  end
  
  def test_checkout_when_last_checkin_reverted_after_checkin
    game = collaborative_games(:agame)
    checkout = game.checkout users(:player1)
    
    game.check_in "somefile.sve"
    assert_equal "somefile.sve", game.last_checkout.savegame
    
    game.revert_last_checkout
    assert_equal "mysavegame2.sve", game.last_checkout.savegame
    
    checkout2 = game.checkout users(:player2)
    assert_equal users(:player2), checkout2.user
  end
  
  def test_revert_when_last_is_reverted
    game = collaborative_games(:agame)
    checkout = game.checkout users(:player1)
    
    game.check_in "somefile.sve"
    assert_equal "somefile.sve", game.last_checkout.savegame
    
    game.revert_last_checkout
    game.revert_last_checkout
    
    assert_equal "mysavegame.sve", game.last_checkout.savegame
    
    checkout2 = game.checkout users(:player2)
    assert_equal users(:player2), checkout2.user
  end
end
