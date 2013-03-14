class SessionsController < ApplicationController
	
	def login
		if signed_in?
			redirect_to root_url
		else
			render 'login'
		end
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			cookies[:remember_token] = {value: user.remember_token,
										expires: 1.day.from_now.utc}
			self.current_user = user
			redirect_back_or portfolio_path(user.portfolios.first.id)
		else
			flash.now[:error] = 'Invalid email/password combination' 
			render 'login'
		end
	end
	
	def new
	end
	
	def destroy
		cookies.delete(:remember_token)
		self.current_user = nil
		redirect_to root_url
	end
end
