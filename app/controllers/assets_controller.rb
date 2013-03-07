class AssetsController < ApplicationController

	def create
		@asset = Asset.new(params[:asset])
		@asset.portfolio_id = params[:portfolio_id]
		if @asset.save
			redirect_to portfolio_path(params[:portfolio_id])
		else
			#handle with an error partial or an alert of some sort
			redirect_to portfolio_path(params[:portfolio_id])
		end
	end

	
end
