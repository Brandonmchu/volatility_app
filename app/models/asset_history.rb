# == Schema Information
#
# Table name: asset_histories
#
#  id             :integer          not null, primary key
#  date           :date
#  open           :float
#  high           :float
#  low            :float
#  close          :float
#  volume         :integer
#  adjusted_close :float
#  asset_symbol   :string(255)
#  asset_id       :integer
#

class AssetHistory < ActiveRecord::Base
  attr_accessible :adjusted_close, :close, :date, :high, :low, :open, :volume, :asset_id, :asset_symbol
  has_and_belongs_to_many :assets

  validates_uniqueness_of :asset_symbol, scope: [:date]

  #working on a function to mass insert:
  # a = YahooFinance::get_historical_quotes_days('yhoo',30)
  # inserts =[]
  # a.each do |line|
  # 	inserts.push "(#{line.join(", ")})"
  # end
  # sql = "INSERT INTO asset_histories SELECT datapoint1 AS id, datapoint2 AS `date` ... 
  # ...datapoint8 AS `adjusted_close` UNION SELECT datapoint9,10,11,12,13,14,15,16, UNION SELECT 
  #datapoint 17... etc"
  # ActiveRecord::Base.connection.execute sql
end
