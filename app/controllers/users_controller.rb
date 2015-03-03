class UsersController < ApplicationController

	def index
    # page  = params[:page].to_i || 1
    # @users = User.visible.select(:id, :name, :email).page(page)
	end

	def show
		@user = User.find_by(id: current_user.id)
	end

	def dashboard
		@dash = User.get_dash(current_user.id)
	end

	def get_info
		@info = User.get_info(current_user.id)
		render :info
	end

	def new
    	@user = User.new
	end

	def create
    	new_user_info = params.require(:user).permit(:name, :email, :password)
    	@user = User.new(new_user_info)

    	if !@user.save
      		render :new
	    else
	      	redirect_to('login')
    	end
	end

	def login
    	@user = User.new()
	end
end
