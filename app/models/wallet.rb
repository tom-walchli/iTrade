class Wallet < ActiveRecord::Base
	belongs_to :user

	def self.create_or_update(uid)
		info = JSON.parse(Btce::TradeAPI.new_from_keyfile.get_info.to_json)
		if info['success'] == 1
			info['return']['funds'].each_key do |key|
				if ['btc', 'usd'].find(key)
					wallet = get_by_currency(uid,key)
					bal = info['return']['funds'][key]
					if wallet
						#update wallet
						wallet.update_attribute(:balance, bal)
					else
						#create wallet
						create(exchange: 'btce',currency: key, balance: bal,user_id: uid)
					end
				end
			end
		end
	end

	def self.get_by_currency(uid,curr, exch='btce')
		return find_by(user_id: uid, currency: curr, exchange: exch)
	end

	def self.update_balance(uid,curr, bal, exch='btce')
		Wallet.get_by_currency(uid,curr,exch).update_attribute(:balance,bal)
	end

end
