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
		a = where('asset_symbol = ?',symbol).select('date,percent_change').order('date DESC')
		stdevarray = []
		(0...a.length-daystocheck).each do |n|
			percentonly =[]
			(n..n+daystocheck-1).each do |m|
				percentonly.push(a[m]['percent_change'])
			end
			mean = percentonly.sum/daystocheck
			variance = percentonly.inject(0){|accum,i|accum + (i-mean)**2}
			std = Math.sqrt(variance/(daystocheck-1))*100
			stdevarray.push([a[n]['date'].to_datetime.to_i*1000,std])
		end
		(a.length-daystocheck...a.length).each do |n|
			stdevarray.push([a[n]['date'].to_datetime.to_i*1000,nil])
		end
		return stdevarray.reverse!.to_json
	end

=begin
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
=end

end
