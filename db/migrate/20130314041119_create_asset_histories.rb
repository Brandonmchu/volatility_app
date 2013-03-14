class CreateAssetHistories < ActiveRecord::Migration
  def change
    create_table :asset_histories do |t|
      t.date :date
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.integer :volume
      t.float :adjusted_close

      t.timestamps
    end
  end
end
