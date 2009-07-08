require 'test_helper'

class Admin::UserControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def test_index
    login_as_admin
    
    get :index
    assert_equal 7, assigns(:users).size
  end
  
  def test_index_as_no_admin
    login_as_no_admin
    get :index
    
    assert_redirected_to root_url
    assert_equal "Access denied", flash[:notice]
  end
  
  def test_show
    login_as_admin
    get :show, :id => users(:player1).id
    
    assert_equal users(:player1), assigns(:user)
  end
  
  def test_show_wrong_id
    login_as_admin
    get :show, :id => 0
    
    assert_redirected_to admin_user_index_path
    assert_equal "User not found", flash[:notice]
  end
  
  def test_revoke_role
    login_as_admin
    users(:player1).has_role!(:gamemanager)
    get :revoke, :id => users(:player1).id, :role => 'gamemanager'
    
    assert_redirected_to admin_user_path(users(:player1))
    assert_equal "Revoked role", flash[:notice]
    assert !users(:player1).has_role?(:gamemanager)
  end
  
  def test_assign_role
    login_as_admin
    get :assign, :id => users(:player1).id, :role => 'gamemanager'
    
    assert_redirected_to admin_user_path(users(:player1))
    assert_equal "Assigned role", flash[:notice]
    assert users(:player1).has_role?(:gamemanager)
  end
  
  private
    def login_as_admin
      @user = users(:auser)
      @session = UserSession.new(@user)
      @session.save
      
      @user.has_role!(:admin)
    end
    
    def login_as_no_admin
      @user = users(:auser)
      @session = UserSession.new(@user)
      @session.save
    end
end
