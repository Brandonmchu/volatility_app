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
#

class AssetHistory < ActiveRecord::Base
  attr_accessible :adjusted_close, :close, :date, :high, :low, :open, :volume, :asset_symbol
  has_and_belongs_to_many :assets

  validates_uniqueness_of :asset_symbol, scope: [:date]

 #def get_stdev(day,symbol,daystocheck)
#		a = ActiveRecord::Base.connection.raw_connection
#	    a.prepare('get_stdev',"WITH numberofdays AS (SELECT percent_change FROM asset_histories WHERE date < $1 AND asset_symbol =$2 ORDER BY date DESC LIMIT $3) SELECT stddev_samp(percent_change) as stdev_percent_change")
#	    a.exec_prepared('get_stdev',[day,symbol,daystocheck])
#	    a.close
 #end

	def self.stdev(day,symbol,daystocheck)
	 	a = select('date,percent_change').where('asset_symbol = ? AND date < ?',symbol,day).limit(daystocheck).order('date DESC')
		if a[-1]['percent_change'] == nil
			return null
		else
			percentonly =[]
			a.each do |pc|
				percentonly.push(pc['percent_change'])
			end
			mean = percentonly.sum/percentonly.length
			variance = percentonly.inject(0){|accum,i|accum + (i-mean)**2}
			std = Math.sqrt(variance/(percentonly.length-1))
			return std
		end
	end
end
