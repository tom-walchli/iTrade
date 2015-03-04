class Decision < ActiveRecord::Base
	belongs_to :user

	after_initialize do
		@evals = Eval.where("updated_at < ?", Time.now).order('updated_at DESC').limit(3)
		make_decision()
	end	

	def make_decision()
		btc_balance = user.wallets.where("currency = btc").balance
		usd_balance = user.wallets.where("currency = usd").balance
		e0 = @evals[0]

		if(usd_balance > 0.01)
			if (e0.buy == true && e0.sell == false) \
				|| (e0.buy_confidence > 0.5 && e0.sell_confidence < 0.5)
				create_transaction('buy')
			end
		end

		if(btc_balance > 0.0001)
			if (e0.sell == true && e0.buy == false) \
				|| (e0.sell_confidence > 0.5 && e0.buy_confidence < 0.5)
				create_transaction('sell')
			end
		end
	end

	def create_transaction(type)
		
	end
end
