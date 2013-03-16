class UsersController < ApplicationController
	before_filter :signed_in_user, :only => [:edit, :update]
	before_filter :correct_user,   :only => [:edit]

	def register
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			# if save works, then a new user has been created,
			# therefore create a remember_token that expires in a day and set the current_user to
			# the user that just signed in. The cookie will keep this person signed in for 1 day
			cookies[:remember_token] = {value: @user.remember_token,
										expires: 1.day.from_now.utc}
			self.current_user = @user
			@user.portfolios.create(portfolio_name: "First Portfolio")
      		flash[:success] = "Welcome! Please add some assets to your portfolio"
      		redirect_to new_portfolio_path
	  	else
	  		#because the save created errors, rendering the same page displays the errors now
	  		render 'register'
  		end
	end

	def edit
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			sign_in @user
			flash.now[:success] = "Account Settings Updated"
			redirect_to edit_user_path
		else
			flash[:error] = "Invalid Save"
			render 'edit'
		end
	end

	private

		def signed_in_user
      unless signed_in?
        store_location
        redirect_to root_path, notice: "Please sign in."
      end
    end

		def correct_user
			if current_user?(User.find(params[:id]))
				@user = User.find(params[:id])
			else
				redirect_to root_path
			end
    end

end
