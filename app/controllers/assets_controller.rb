class AssetsController < ApplicationController

	def create
		@current_portfolio = current_user.portfolios.find_by_id(params[:portfolio_id])
		@asset = @current_portfolio.assets.build(params[:asset])
		@asset.save
		redirect_to portfolio_path(params[:portfolio_id])

	end
end
