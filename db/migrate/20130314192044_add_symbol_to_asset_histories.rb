class AddSymbolToAssetHistories < ActiveRecord::Migration
  def change
  		add_column :asset_histories, :asset_symbol, :string
  		add_column :asset_histories, :asset_id, :integer
  		add_column :assets, :asset_history_id, :integer
  		add_index :asset_histories, [:date, :asset_symbol], :unique => true
  end
end
