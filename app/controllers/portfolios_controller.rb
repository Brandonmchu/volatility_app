class PortfoliosController < ApplicationController
before_filter :signed_in_user
before_filter :correct_user, only: [:show, :edit, :destroy]
before_filter :has_one_portfolio, only: [:destroy]

	def edit
		@userportfolios = current_user.portfolios.paginate(page: params[:page])
		@current_portfolio = current_user.portfolios.find_by_id(params[:id])
		@asset = @current_portfolio.assets.build
		@assets =@current_portfolio.assets.paginate(page: params[:page])
	end

	def index
		if current_user.portfolios.count == 1
			redirect_to current_user.portfolios.first
		else
			@userportfolios = current_user.portfolios.paginate(page: params[:page])
			@portfolio = current_user.portfolios.build
			render 'index'
		end
	end

	def show
		@current_portfolio = current_user.portfolios.find_by_id(params[:id])
		@userportfolios = current_user.portfolios.paginate(page: params[:page])
	end

	def create
		@portfolio = current_user.portfolios.new(params[:portfolio])
		if @portfolio.save
			flash[:success] = "New Portfolio Created!"
			redirect_to portfolio_path(@portfolio.id)
		else
			@asset = Asset.new
			render 'new'
		end
	end

	def new
		@portfolio = current_user.portfolios.new
		5.times {@portfolio.assets.build}
		@asset = Asset.new
	end

	def destroy
			@portfolio.destroy
			redirect_to edit_portfolio_path(current_user.portfolios.first)
	end
	def update
		@current_portfolio = Portfolio.find_by_id(params[:portfolio_id])
		@current_portfolio.update_attributes(params[:portfolio])
		redirect_to edit_portfolio_path(@current_portfolio.id)
	end


	private
	def correct_user
		@portfolio = current_user.portfolios.find_by_id(params[:id])
		flash[:forbidden] = "Sorry, you are not allowed to view that portfolio" if @portfolio.nil?
		redirect_to portfolio_path(current_user.portfolios.first.id) if @portfolio.nil?
	end

	def has_one_portfolio
		flash[:error] = "Sorry, you are not allowed have less than one portfolio" if current_user.portfolios.count == 1
		redirect_to edit_portfolio_path(current_user.portfolios.first) if current_user.portfolios.count == 1
	end

end
