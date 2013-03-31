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
#  percent_change :float
#  stdev21day     :float
#  stdev63day     :float
#  stdev252day    :float
#

class AssetHistory < ActiveRecord::Base
  attr_accessible :adjusted_close, :close, :date, :high, :low, :open, :volume, :asset_symbol
  has_and_belongs_to_many :assets

  validates_uniqueness_of :asset_symbol, scope: [:date]


def self.stdev(symbol,daystocheck)
	a =[]
	q = ActiveRecord::Base.connection.method(:quote)
	ActiveRecord::Base.connection.execute(%Q{WITH percentchanges AS (SELECT date,close,-1+close/lag(close) OVER (ORDER BY date) AS pct_change FROM asset_histories WHERE asset_symbol = #{q[symbol]} ORDER BY date) SELECT date,(|/250)*stddev_samp(pct_change) OVER (ORDER BY date ROWS BETWEEN #{q[daystocheck-1]} PRECEDING AND 0 FOLLOWING) AS stdev FROM percentchanges}).each {|tuple| a.push([tuple['date'].to_datetime.to_i*1000,tuple['stdev'].to_f])}
	return a.drop(daystocheck).to_json
end

	
end
