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
#

class AssetHistory < ActiveRecord::Base
  attr_accessible :adjusted_close, :close, :date, :high, :low, :open, :volume, :asset_symbol
  has_and_belongs_to_many :assets

  validates_uniqueness_of :asset_symbol, scope: [:date]

end
