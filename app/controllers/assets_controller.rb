class AssetsController < ApplicationController

	def create
		@asset = current_portfolio.assets.build(params[:asset])
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
	
	def update
		@asset = Asset.find_by_id(params[:id])
		if @asset.update_attributes(params[:asset])
      		flash[:success] = "Asset Updated"
      		redirect_to edit_portfolio_path(current_portfolio.id) 
    	else
    		flash[:error] = "Asset Not Updated. Please make sure all fields are filled out."
      		redirect_to edit_portfolio_path(current_portfolio.id) 
    	end
	end


	def destroy
		Asset.find_by_id(params[:id]).destroy
    	redirect_to edit_portfolio_path(current_portfolio)
	end

end
