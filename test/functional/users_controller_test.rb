require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic # I don't get why it belongs here and not in test_helper.rb
  
  def test_new
    get :new
    
    assert_response :success

    post :create, :user => { :email => "someemail@email.info", :name => "Some name",
                             :password => "apass", :password_confirmation => "apass" }
    
    assert_redirected_to root_url
    assert_equal "Account registered!", flash[:notice]
  end
  
  def test_new_with_errors
    get :new
    
    assert_response :success
    
    post :create, :user => { :email => "someemail@email.info", :name => "Some name",
                             :password => "apass", :password_confirmation => "password_do_not_match" }
    
    assert_response :success
    assert_select "h2", "1 error prohibited this user from being saved"
  end
  
  def test_update_without_login
    get :update
    assert_redirected_to root_url
    
    assert_equal "You must be logged in to access this page", flash[:notice]
  end
  
  def test_update
    UserSession.create(users(:auser))
    get :edit
    assert_response :success
    
    assert_equal users(:auser), assigns(:user)
    
    post :update, :user => { :email => "letschangethis@copy.info", :name => "Some name" }
    
    assert_redirected_to account_url
    
    assert_equal "Account updated!", flash[:notice]
  end
  
  def test_update_with_problems
    UserSession.create(users(:auser))
    
    post :update, :user => { :email => users(:anotheruser).email, :name => "Some name" }
    
    assert_response :success
    assert_select "h2", "1 error prohibited this user from being saved"
  end
  
  def test_update_change_password
    UserSession.create(users(:auser))
    
    post :update, :user => { :email => users(:auser).email, :name => users(:auser).name,
                             :password => "newpass", :password_confirmation => "newpass" }
    
    assert_redirected_to account_url
    assert_equal "Account updated!", flash[:notice]
  end
end
