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

require 'test_helper'

class CollaborativeGamesControllerTest < ActionController::TestCase
  setup :activate_authlogic
  setup :create_games

  def test_new_game
    @user_session = UserSession.new(users(:auser))
    @user_session.save
    
    get :new
    assert_response :success
    
    post :create, :collaborative_game => { :name => "A new game", :description => "This is my game..." }
    
    assert_redirected_to collaborative_game_path(assigns(:game))
    assert_equal "Game created", flash[:notice]
  end
  
  def test_new_game_without_login
    get :new
    assert_redirected_to root_url
    assert_equal "You must be logged in to access this page", flash[:notice]
    
    post :create, :collaborative_game => { :name => "A new game", :description => "This is my game..." }
    assert_redirected_to root_url
    assert_equal "You must be logged in to access this page", flash[:notice]
  end
  
  def test_edit_game
    @user_session = UserSession.new(users(:auser))
    @user_session.save
    
    get :edit, :id => @some_game.id
    
    assert_response :success
    assert_equal @some_game, assigns(:game)
    
    post :update, {:id => @some_game.id, :collaborative_game => { :name => "Updated name", :description => "Updated description" } }
    
    assert_redirected_to collaborative_game_path(@some_game)
    assert_equal "Game updated", flash[:notice]
    assert_equal "Updated name", assigns(:game).name
    assert_equal "Updated description", assigns(:game).description
  end
  
  def test_edit_game_with_wrong_id
    @user_session = UserSession.new(users(:auser))
    @user_session.save
    
    get :edit, :id => 0
    assert_redirected_to root_url
    assert_equal "Game not found", flash[:error]
  end
  
  def test_edit_game_without_login
    get :edit, :id => @some_game.id
    assert_redirected_to root_url
    assert_equal "You must be logged in to access this page", flash[:notice]
    
    post :update, {:id => @some_game.id, :collaborative_game => { :name => "Updated name", :description => "Updated description" } }
    assert_redirected_to root_url
    assert_equal "You must be logged in to access this page", flash[:notice]
  end
  
  def test_edit_game_with_wrong_login
    @user_session = UserSession.new(users(:anotheruser))
    @user_session.save
    
    get :edit, :id => @some_game.id
    assert_redirected_to root_url
    assert_equal "Access denied", flash[:notice]
    
    post :update, {:id => @some_game.id, :collaborative_game => { :name => "Updated name", :description => "Updated description" } }
    assert_redirected_to root_url
    assert_equal "Access denied", flash[:notice]
  end
  
  def test_join_game
    @user_session = UserSession.new(users(:anotheruser))
    @user_session.save
    
    get :join, :id => @some_game.id
    assert_redirected_to collaborative_game_path(@some_game)
    assert_equal "Joined the game.", flash[:notice]
    
    # Try to join again => an error should popup
    get :join, :id => @some_game.id
    assert_redirected_to collaborative_game_path(@some_game)
    assert_equal "You already joined the game.", flash[:error]
    
    # create another game, and join that to
    other_game = CollaborativeGame.new({:name => "Some game", :description => "Extended description"})
    other_game.coordinator = users(:auser)
    other_game.save
    
    get :join, :id => other_game.id
    assert_redirected_to collaborative_game_path(other_game)
    assert_equal "Joined the game.", flash[:notice]
  end
  
  def test_join_game_without_login
    get :join, :id => @some_game.id
    assert_redirected_to root_url
    assert_equal "You must be logged in to access this page", flash[:notice]
  end
  
  def test_join_game_with_wrong_id
    @user_session = UserSession.new(users(:anotheruser))
    @user_session.save
    get :join, :id => 0 # Let's hope this does not exist...
    
    assert_redirected_to root_url
    assert_equal "Game not found", flash[:error]
  end
  
  def test_checkout
    @user_session = UserSession.new(users(:player3))
    @user_session.save

    game = collaborative_games(:agame)
    get :checkout, :id => game
    
    assert_redirected_to collaborative_game_path(collaborative_games(:agame))
    assert_equal "You checked out the game. Please check it back in when you are ready.", flash[:notice]
      
    assert !game.is_open_to_user?(users(:player2))
  end
  
  private
    def create_games
      @some_game = CollaborativeGame.new({:name => "Some game", :description => "Extended description"})
      @some_game.coordinator = users(:auser)
      @some_game.save
      users(:auser).has_role!(:gamemanager)
      users(:auser).has_role!(:coordinator, @some_game)
    end
end
