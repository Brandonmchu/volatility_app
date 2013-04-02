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
			sign_in user
			updateassets
			if user.portfolios.first.nil?
				redirect_back_or new_portfolio_path
			else
				redirect_back_or portfolio_path(user.portfolios.first.id)
			end
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
