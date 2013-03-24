class RemoveAssetIdFromAssetHistories < ActiveRecord::Migration
  def up
  		remove_column :asset_histories, :asset_id
  		remove_column :assets, :asset_history_id
  end

  def down
  	  	add_column :asset_histories, :asset_id, :integer
  		add_column :assets, :asset_history_id, :integer
  end
end
