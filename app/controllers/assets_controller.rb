class AssetsController < ApplicationController

	def create
		@asset = Asset.new(params[:asset])
		@asset.portfolio_id = params[:portfolio_id]
		if @asset.save
			redirect_to portfolio_path(params[:portfolio_id])
		else
			redirect_to root_url
		end
	end
end
