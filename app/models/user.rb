class User < ActiveRecord::Base
	has_many 	:wallets
	has_many 	:trades
	has_one		:dashboard
	has_many	:decisions
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

#
# Class methods
# =============
#

	def self.get_dash(id)
		return "Hello World!"
	end

#
# Instance methods
# ================
#


end
