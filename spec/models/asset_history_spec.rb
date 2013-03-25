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

require 'spec_helper'

describe AssetHistory do
  pending "add some examples to (or delete) #{__FILE__}"
end
