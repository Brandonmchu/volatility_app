class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :portfolio_name
      t.integer :user_id

      t.timestamps
    end
  end
end
