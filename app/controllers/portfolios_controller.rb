class PortfoliosController < ApplicationController
before_filter :signed_in_user
before_filter :correct_user, only: [:show]

	def show
		@asset = Asset.new#current_user.portfolios.assets.build(params[:micropost])
		@portfolios = current_user.portfolios
		@portfolio = current_user.portfolios.build
		@current_portfolio = current_user.portfolios.find_by_id(params[:id])
	end

	def index
		if current_user.portfolios.count == 1
			redirect_to current_user.portfolios.first
		else
			@userportfolios = current_user.portfolios
			@portfolio = current_user.portfolios.build
			render 'index'
		end
	end

	def create
		@portfolio = current_user.portfolios.build(params[:portfolio])
		@portfolio.save
		@userportfolios = current_user.portfolios
		render 'index'
	end
	
	private
	def correct_user
		@portfolio = current_user.portfolios.find_by_id(params[:id])
		redirect_to root_url if @portfolio.nil?
	end

end
