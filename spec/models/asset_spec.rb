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

require 'spec_helper'

describe Asset do
  pending "add some examples to (or delete) #{__FILE__}"
end
