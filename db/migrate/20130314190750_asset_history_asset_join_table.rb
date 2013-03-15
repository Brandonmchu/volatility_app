class AssetHistoryAssetJoinTable < ActiveRecord::Migration
  def up
  	create_table :asset_histories_assets, :id=> false do |t|
  		t.integer :asset_id
  		t.integer :asset_history_id
  	end
  end

  def down
  	drop_table :asset_histories_assets
  end
end
