class Asset < ActiveRecord::Base
  attr_accessible :asset_name, :asset_symbol, :cost, :portfolio_id, :purchase_date, :shares
  belongs_to :portfolios
end
