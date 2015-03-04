class Trade < ActiveRecord::Base
	belongs_to :user

#
# Class methods
# ================
#
	# allows to have a column called type
	self.inheritance_column = nil
	
	def self.open_orders()

	end

#
# Instance methods
# ================
#

	#trade is created in decision.create_trade 
	after_initialize do
		@price_span 	= evaluate_price_span()
		rel_span	= evaluate_rel_span(@price_span)
		trade_amount = assess_trade_amount(rel_span)
		kickoff_trade(trade_amount)
	end

	def evaluate_price_span()
		what = (type == 'buy' ? 'asks' : 'bids')
		return rake_up_depth(what)
	end

	# evaluate the span of offered trade prices
	def rake_up_depth(what)
		rv = Btce::Depth.new('btc_usd').json
		depth = rv['btc_usd']
		raked_up = 0
		price_span = []
		depth[what].each do |d|
			raked_up += d[1]
			price_span.push( [ d[0] , [raked_up,amount_available].min ] )
			if raked_up >= amount_available
			 	break
			end 
		end
		puts "PRICE SPAN: #{price_span}"
		return price_span
	end

	def evaluate_rel_span(span)
		rel_span = span.map do |s|
			[(s[0] - span[0][0]).abs / span[0][0] , s[1] / amount_available]
		end
		return rel_span
	end

	def assess_trade_amount(span)
#   	=========================		
#		debug
		return amount_available
#  		=========================		
		ann_eval = AnnEval.find(ann_eval_id)
		puts "BUY CONFIDENCE: #{ann_eval.buy_confidence}"
		case type
		when 'buy'
			if ann_eval.buy_confidence > 0.8 
				trade_amount_rel = 1.
			elsif ann_eval.buy_confidence > 0.6
				trade_amount_rel = 0.8
			elsif ann_eval.buy_confidence > 0.5
				trade_amount_rel = 0.6
			end
		when 'sell'
			if ann_eval.sell_confidence > 0.8 
				trade_amount_rel = 1.
			elsif ann_eval.sell_confidence > 0.6
				trade_amount_rel = 0.8
			elsif ann_eval.sell_confidence > 0.5
				trade_amount_rel = 0.6
			end
		end
		return amount_available * trade_amount_rel
	end

	def kickoff_trade(amount)

#       ============================================================
#       ============================================================
#  		!!!!! UNCOMMENTING THIS LINE WILL START ACTIVE TRADING !!!!!		
#       ============================================================		
#		trd = Btce::TradeAPI.new_from_keyfile.trade('btc_usd',type,@price_span[0][0],@price_span[0][1])
# 		============================================================		
# 		============================================================		

#   	=========================		
#		debug:
		trd = {"success"=>1,"return"=>{
								"received"=>0.1,
								"remains"=>0,
								"order_id"=>0,
								"funds"=>{"usd"=>325,"btc"=>2.498,"sc"=>121.998,"ltc"=>0,"ruc"=>0,"nmc"=>0}
							}
				}
#  		=========================		

		rv = trd['return']
		if trd['success'] == 1
			parms = {:status => 'placed',:foreign_id => "#{rv['order_id']}"}
			update_attributes(parms)

			curr = (type == 'buy' ? 'usd' : 'btc')
				wlt = Wallet.get_by_currency(user.id, curr)
				old_bal = wlt.balance
				old_hold = wlt.on_hold
				puts "HOLD: #{old_bal}"
				new_bals = {:balance => old_bal - rv['received'], :on_hold => (old_hold || 0) + rv['received']}
				wlt.update_attributes(new_bals)
		else
			parms = {:status => 'error',:foreign_id => "#{rv['order_id']}"}
			update_attributes(parms)
		end
	end
end
