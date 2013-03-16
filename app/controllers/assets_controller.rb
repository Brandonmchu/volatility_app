class AssetsController < ApplicationController

	def create
		@asset = Asset.new(params[:asset])
		@asset.portfolio_id = params[:portfolio_id]
		if params[:editpage]
			if @asset.save
				redirect_to edit_portfolio_path(params[:portfolio_id])
			else
				#handle with an error partial or an alert of some sort
				redirect_to edit_portfolio_path(params[:portfolio_id])
			end
		else
			if @asset.save
				redirect_to portfolio_path(params[:portfolio_id])
			else
				#handle with an error partial or an alert of some sort
				redirect_to portfolio_path(params[:portfolio_id])
			end
		end
	end
	def destroy
		Asset.find(params[:id]).destroy
    redirect_to edit_portfolio_path(current_portfolio)
	end

end
