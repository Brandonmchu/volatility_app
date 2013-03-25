class AssetsController < ApplicationController

	def create
		@asset = current_portfolio.assets.build(params[:asset])
		@asset.portfolio_id = params[:portfolio_id]

		respond_to do |format|
			if params[:editpage]
				if @asset.save
					format.html { redirect_to edit_portfolio_path(params[:portfolio_id]) }
					format.js
				else
					#handle with an error partial or an alert of some sort
					format.html { redirect_to edit_portfolio_path(params[:portfolio_id]) }
				end
			else
				if @asset.save
					format.html { redirect_to portfolio_path(params[:portfolio_id]) }
				else
					#handle with an error partial or an alert of some sort
					format.html { redirect_to portfolio_path(params[:portfolio_id]) }
				end
			end
		end
	end

	def edit
		@asset = Asset.find_by_id(params[:id])
		respond_to do |format|
			format.html {render 'portfolios/edit'}
			format.js
		end
	end

	def update
		@asset = Asset.find_by_id(params[:id])
		if @asset.update_attributes(params[:asset])
			redirect_to edit_portfolio_path(params[:portfolio_id])
			flash.now[:success] = "Asset info Updated!"
		else
			flash[:error] = "Asset Not Updated. Please make sure all fields are filled out."
      		redirect_to edit_portfolio_path(params[:portfolio_id])
		end
	end

	def destroy
		Asset.find(params[:id]).destroy
		flash.now[:success] = "Asset deleted"
		redirect_to edit_portfolio_path(current_portfolio.id)
	end

end
