class RemoveTimestampsFromAssetHistory < ActiveRecord::Migration
  def up
    remove_column :asset_histories, :created_at
    remove_column :asset_histories, :updated_at
  end

  def down
    add_column :asset_histories, :updated_at, :string
    add_column :asset_histories, :created_at, :string
  end
end
