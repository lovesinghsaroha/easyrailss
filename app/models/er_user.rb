class ErUser < ApplicationRecord
	has_secure_password
	validates_presence_of :email
	validates_confirmation_of :password
	validates_uniqueness_of :email
end
