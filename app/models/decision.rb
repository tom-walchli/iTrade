class Decision < ActiveRecord::Base
	belongs_to :user

	# decision is created in DecisionsController.create()
	after_initialize do
		@evals = AnnEval.where("updated_at < ?", Time.now).order('updated_at DESC').limit(3)
		make_decision()
	end	

	def make_decision()
		@btc_balance = user.wallets.where("currency = 'btc'")[0].balance
		@usd_balance = user.wallets.where("currency = 'usd'")[0].balance
		e0 = @evals[0]

		if(@usd_balance > 0.01)
			if (e0.buy == true && e0.sell == false) \
				|| (e0.buy_confidence > 0.5 && e0.sell_confidence < 0.5)
				create_trade('buy')
			end
		end

#  		====================
#		debug:
		create_trade('sell')
		return
# 		====================
		if (@btc_balance > 0.0001)
			if (e0.sell == true && e0.buy == false) \
				|| (e0.sell_confidence > 0.5 && e0.buy_confidence < 0.5)
				create_trade('sell')
			end
		end
	end

	def create_trade(typ)
		parms = {}
		parms[:type]			= typ
		parms[:f_currency]		= (typ == 'buy'  ? 'usd' : 'btc')
		parms[:t_currency]		= (typ == 'sell' ? 'usd' : 'btc')
		parms[:user_id]			= user.id
		parms[:ann_eval_id]		= @evals[0].id
		parms[:exchange]		= 'btce'
		parms[:amount_available]= (typ == 'buy' ? @usd_balance : @btc_balance)
		parms[:status]			= 'decision'
		Trade.create(parms)
	end
end
