# == Schema Information
#
# Table name: assets
#
#  id            :integer          not null, primary key
#  asset_name    :string(255)
#  asset_symbol  :string(255)
#  shares        :float
#  cost          :float
#  purchase_date :date
#  portfolio_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Asset < ActiveRecord::Base
  attr_accessible :asset_name, :asset_symbol, :cost, :portfolio_id, :purchase_date, :shares
  belongs_to :portfolio
end
