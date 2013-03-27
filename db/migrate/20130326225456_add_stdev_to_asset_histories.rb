class AddStdevToAssetHistories < ActiveRecord::Migration
  def change
  	add_column :asset_histories, :stdev21day, :float
  	add_column :asset_histories, :stdev63day, :float
  	add_column :asset_histories, :stdev252day, :float
  end
end
