class AddIndexToAssetHistoriesAssetSymbol < ActiveRecord::Migration
  def change
  	add_index :asset_histories, :asset_symbol
  	add_index :asset_histories_assets, [:asset_id,:asset_history_id], unique: true
  end
end
