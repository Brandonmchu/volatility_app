# == Schema Information
#
# Table name: portfolios
#
#  id             :integer          not null, primary key
#  portfolio_name :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Portfolio < ActiveRecord::Base
  attr_accessible :portfolio_name, :assets_attributes

  validates :portfolio_name, presence: true
  belongs_to :user
  has_many :assets, :dependent => :destroy

  accepts_nested_attributes_for :assets, :reject_if => lambda {|a| a[:asset_symbol].blank? || a[:purchase_date].blank? || a[:shares].blank? || a[:cost].blank?}
end
