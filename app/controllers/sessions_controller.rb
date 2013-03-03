class SessionsController < ApplicationController
	
	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			cookies[:remember_token] = {value: user.remember_token,
										expires: 1.day.from_now.utc}
			self.current_user = user
		else
			flash.now[:error] = 'Invalid email/password combination' 
			render 'signin'
		end
	end
	
	def new
	end
	
	def destroy
	end
end
