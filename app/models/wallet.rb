class Wallet < ActiveRecord::Base
	belongs_to :user

	@failed_count = 0
	def self.create_or_update(uid)
		info = Btce::TradeAPI.new_from_keyfile.get_info
		puts "===================================================="
		puts "INFO: #{info}"
		puts "===================================================="
		if info['success'] == 1
			@failed_count = 0
			info['return']['funds'].each_key do |key|
				if ['btc', 'usd'].include?(key)
					wallet = get_by_currency(uid,key)
					bal = info['return']['funds'][key]
					if wallet
						#update wallet
						wallet.update_attributes(:balance => bal, :on_hold => 0)
					else
						#create wallet
						create(exchange: 'btce',currency: key, balance: bal,user_id: uid, on_hold: 0)
					end
				end
			end
		elsif @failed_count < 3 
			sleep(1)
			@failed_count += 1;
			create_or_update(uid)
		end
	end

	def self.get_by_currency(uid,curr, exch='btce')
		return find_by(user_id: uid, currency: curr, exchange: exch)
	end

	def self.update_balance(uid,curr, bal, exch='btce')
		Wallet.get_by_currency(uid,curr,exch).update_attribute(:balance,bal)
	end

end
