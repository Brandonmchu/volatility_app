module SessionsHelper

  def sign_in(user)
      cookies.permanent[:remember_token] = user.remember_token
      # cookies[:remember_token] = { value: user.remember_token,
      #                              expires: 20.years.from_now }
      self.current_user = user
  end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user=(user)
		@current_user = user
	end

  def current_user?(user)
    current_user == user
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

	def current_portfolio
		@current_portfolio ||= current_user.portfolios.first
	end

	# This method is explained in the asset.rb model
	def updateassets 
		current_user.assets.each do |assetentry|
		   	mostrecentdate = AssetHistory.find(:all, :select=>'date',:order=>'date DESC',:conditions=>{:asset_symbol=>assetentry.asset_symbol},:limit=>1)
        	numberofdays = (Date.today - mostrecentdate[0].date).to_i
      	   	prices = YahooFinance::get_historical_quotes_days(assetentry.asset_symbol,numberofdays) 
      		prices.each do |priceentry| 
        		priceentry.push(assetentry.asset_symbol) 
      		end
      		columns = [:date,:open,:high,:low,:close,:volume,:adjusted_close,:asset_symbol]
      		AssetHistory.import columns,prices 
      
	        assethistoryids = AssetHistory.find(:all, :select=>'id',:order=>'date DESC', :conditions=>{:asset_symbol=>assetentry.asset_symbol}, :limit=>numberofdays)
	        ahids = "(#{assethistoryids.map{|a| "#{a.id}"}.join(",")})"
	        values = assethistoryids.map{|a| "(#{assetentry.id},#{a.id})"}.join(",") 
      		ActiveRecord::Base.connection.execute("WITH notinyet(asset_id,asset_history_id) AS (VALUES#{values}) INSERT INTO asset_histories_assets (asset_id,asset_history_id) SELECT * FROM notinyet WHERE NOT EXISTS(SELECT asset_id FROM asset_histories_assets WHERE asset_id = #{assetentry.id} AND asset_history_id IN #{ahids})")
      	end
    end

end
