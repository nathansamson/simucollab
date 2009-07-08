class User < ActiveRecord::Base
	validates_presence_of :name
	validates_length_of :name, :minimum => 5

	acts_as_authentic
	acts_as_authorization_subject
end
