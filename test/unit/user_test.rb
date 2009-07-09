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

class UserTest < ActiveSupport::TestCase
  def test_new_user
    user = User.new
    user.email = 'auniquemail@mail.org'
    user.name = 'My name'
    user.password = 'apassword'
    user.password_confirmation = 'apassword'
    
    assert user.save
  end
  
  def test_new_user_incorrect_email
    user = User.new
    user.email = 'nomail@org'
    user.name = 'My name'
    user.password = 'apassword'
    user.password_confirmation = 'apassword'
    
    assert !user.save
  end
  
  def test_new_user_not_unique_email
    user = User.new
    user.email = 'anemail@email.com'
    user.name = 'My name'
    user.password = 'apassword'
    user.password_confirmation = 'apassword'
    
    assert !user.save
  end
  
  def test_new_user_no_name
    user = User.new
    user.email = 'google@email.com'
    user.name = ' '
    user.password = 'apassword'
    user.password_confirmation = 'apassword'
    
    assert !user.save
  end
  
  def test_new_user_passwords_do_not_match
    user = User.new
    user.email = 'google@email.com'
    user.name = 'My name'
    user.password = 'apassword'
    user.password_confirmation = 'anotherpassword'
    
    assert !user.save
  end
  
  def test_new_user_password_too_short
    user = User.new
    user.email = 'google@email.com'
    user.name = 'My name'
    user.password = 'apa'
    user.password_confirmation = 'apa'
    
    assert !user.save
  end
  
  def test_new_user_name_too_short
    user = User.new
    user.email = 'google@email.com'
    user.name = 'name'
    user.password = 'apassword'
    user.password_confirmation = 'apassword'
    
    assert !user.save
  end
end
