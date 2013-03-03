class UsersController < ApplicationController

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

      		flash[:success] = "Welcome! Please create a portfolio!"
      		redirect_to manage_path #redirect to manage for creating a portfolio
	  	else
	  		#because the save created errors, rendering the same page displays the errors now
	  		render 'register' 
  		end
	end

end
