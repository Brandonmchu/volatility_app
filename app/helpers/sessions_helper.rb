module SessionsHelper

	def current_user
		@user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user=(user)
		@current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def signed_in_user
      unless signed_in?
        store_location
        redirect_to login_path, notice: "Please sign in."
      end
    end

   	def store_location
		session[:return_to] = request.url
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end


end
