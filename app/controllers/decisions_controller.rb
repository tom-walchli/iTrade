class DecisionsController < ApplicationController

	def create
		@user 		= User.find params[:user_id]
		@decision 	= @user.decisions.create()
		redirect_to '/'
	end

end
