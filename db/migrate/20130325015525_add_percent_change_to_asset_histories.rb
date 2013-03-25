class AddPercentChangeToAssetHistories < ActiveRecord::Migration
  def change
  	add_column :asset_histories, :percent_change, :float
  end
end
