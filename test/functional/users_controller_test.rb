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

class UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic # I don't get why it belongs here and not in test_helper.rb
  
  def test_new
    get :new
    
    assert_response :success

    post :create, :user => { :email => "someemail@email.info", :name => "Some name",
                             :password => "apass", :password_confirmation => "apass" }
    
    assert_redirected_to root_url
    assert_equal "Account registered!", flash[:notice]
    
    user = User.find_by_email("someemail@email.info")
    assert !user.has_role?(:admin)
  end
  
  def test_new_and_make_admin
    User.all.each do |user|
      user.destroy
    end
    
    post :create, :user => { :email => "someemail@email.info", :name => "Some name",
                             :password => "apass", :password_confirmation => "apass" }
    
    assert_redirected_to root_url
    assert_equal "Account registered!", flash[:notice]
    user = User.find_by_email("someemail@email.info")
    assert user.has_role? :admin
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
