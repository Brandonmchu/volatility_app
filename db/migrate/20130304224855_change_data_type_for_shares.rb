class ChangeDataTypeForShares < ActiveRecord::Migration
  def up
  	change_table :assets do |t|
  		t.change :shares, :float
  	end
  end

  def down
  	change_table :assets do |t|
  		t.change :shares, :integer
  	end
  end
end
