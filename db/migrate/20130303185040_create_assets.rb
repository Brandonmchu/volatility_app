class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :asset_name
      t.string :asset_symbol
      t.integer :shares
      t.float :cost
      t.date :purchase_date
      t.integer :portfolio_id

      t.timestamps
    end
  end
end
