class DeleteUnnecessaryColumns < ActiveRecord::Migration
  def up
  		remove_column :asset_histories, :percent_change
  		remove_column :asset_histories, :stdev21day
  		remove_column :asset_histories, :stdev63day
  		remove_column :asset_histories, :stdev252day
  		remove_column :assets, :asset_name
  		
  end

  def down
  	add_column :asset_histories, :percent_change, :float
  end
end
