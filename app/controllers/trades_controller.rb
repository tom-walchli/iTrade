class TradesController < ApplicationController
	def pending
		Trade.pending_trades()
		@user 		= User.find params[:user_id]
		wallets 	= @user.wallets
		trades 		= @user.trades.where('updated_at > ?', Time.now - 1.month).order('updated_at DESC').limit(50)
		latest_eval = AnnEval.order('updated_at DESC').limit(1)[0]
	   	render(json: {user: @user.to_json, wallets: wallets ,trades: trades, latest_eval: latest_eval})
	end
end
