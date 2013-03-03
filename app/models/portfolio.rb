class Portfolio < ActiveRecord::Base
  attr_accessible :portfolio_name, :user_id
  belongs_to :user
  has_many :assets
end
