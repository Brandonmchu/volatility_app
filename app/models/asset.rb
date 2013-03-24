# == Schema Information
#
# Table name: assets
#
#  id            :integer          not null, primary key
#  asset_name    :string(255)
#  asset_symbol  :string(255)
#  shares        :float
#  cost          :float
#  purchase_date :date
#  portfolio_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Asset < ActiveRecord::Base
  attr_accessible :asset_name, :asset_symbol, :cost, :portfolio_id, :purchase_date, :shares
  validates :asset_symbol, presence: true
  validates :shares, presence: true
  validates :cost, presence: true
  validates :purchase_date, presence: true
  belongs_to :portfolio
  has_and_belongs_to_many :asset_histories

  before_save { |asset| asset.asset_symbol = asset_symbol.downcase }
  
  after_save :populatepricehistory
  
  private
  	def populatepricehistory
      numberofdays = 1000
      unless AssetHistory.find_by_asset_symbol(self.asset_symbol).nil?
        mostrecentdate = AssetHistory.find(:all, :select=>'date',:order=>'date DESC',:conditions=>{:asset_symbol=>'aapl'},:limit=>1)
        numberofdays = (Date.today - mostrecentdate[0].date).to_i
      end
      
      prices = YahooFinance::get_historical_quotes_days(self.asset_symbol,numberofdays) 
      prices.each do |line| 
        line.push(self.asset_symbol) 
      end
      columns = [:date,:open,:high,:low,:close,:volume,:adjusted_close,:asset_symbol]
      AssetHistory.import columns,prices 
      

      assethistoryids = AssetHistory.find(:all, :select=>'id', :conditions=>{:asset_symbol=>self.asset_symbol})
      values = assethistoryids.map{|assethistory| "(#{self.id},#{assethistory.id})"}.join(",") 
      ActiveRecord::Base.connection.execute("INSERT INTO asset_histories_assets (asset_id,asset_history_id) VALUES #{values}") 
  	end

    # first we set the number of days of price history to 1000. This is the default.
    # We run a simple check to see if we already have the Asset in our AssetHistory table. 
    # If we do have it, we look for the most recent date that is in our database so that we only have to
    # update the difference in the dates. I.e. If we last updated it last month, we only need 30 days.
    # We set the numberofdays of price history to this difference.
    # If we don't have price history of the asset, then we default look for 1000 days of data.

    # prices = ... is the Yahoo Finance API which gets an array of data looking like 
    # {[date,open, close,high,low,volume,adjusted_close],[date2,open2,close2,high2,low2,volume2,adjusted_close2] etc.}
    # we iterate through the prices to add the stock symbol to that array because that is needed

    # We will use activerecord-import gem to mass insert into the database.
    # Part of the mass insert requirements is to list the column names in an array
    # columns = ... is the name of the columns
    # notice that the prices variable is the values in the exact same order as the columns
    # AssetHistory.import columns,prices is the gem which mass imports the data into AssetHistory

    # Before we go into assethistoryids = ... a precursor:

    # Because Assets have many AssetHistorys, and AssetHistories have many Assets 
    # (i.e. 2 people can have same stock), this is known as a many to many relationship, aka
    # Has And Belongs To Many (HABTM).
    # HABTM models have a separate table that maps the relationships that connect each record. 
    # Therefore Google owned by User 1 might be asset 5 and Google owned by User 2 might be asset 7.
    # In order for Asset 5 to be linked to the Asset Histories for Google, there will be the separate table
    # mentioned earlier known as the Join Table. This table has 2 columns, asset_id and asset_history_id. 
    # So if the price data populated the first 30 entries for Google with asset_history_id 19-49, then in
    # the join table we would expect to see the below: [each bracket is a new row]
    # (5,19), (5,20) ... (5,49) ...(7,19), (7,20) ... (7,49)
    # This is how Google owned by User 1 will be connected to the same price data 
    # (rows 19-49 in the asset_history model) that Google owned by User2 is connected to.

    # The next bit of code is to mass insert the Join Table. Normally this is autopopulated, but it doesn't
    # auto populate with a mass import (which we did), so we need to manually populate the Join Table
    # 
    # :select=>'id' is a way to only return the id column. 
    # assethistoryids = ... is a way to search the AssetHistory table for the stock we just created.
    # Basically I'm finding all the price data history we just mass inserted, and returning an array
    # of the asset_history_id
    # values = ... is joining each asset_history_id with the asset_id that was just created.
    # values will look like a string of: '(5,19),(5,20),(5,21)...' etc
    # ActiveRecord::Base.connection.execute is a command to execute SQL statements
    # In other words, we could open up our Postgres database and type that statement to have the commands
    # execute under that GUI. However since we won't always have the Postgres GUI, this is how ruby executes
    # the commands of an SQL statement

    # I use an SQL statement because SQL statements are one of the fastest way to mass import and because
    # we are importing into the Join Table. I'm not sure if you can use the gem to import into the 
    # Join Table so this makes things easier. Notice the name of the join table is referenced in the 
    # SQL statement. It is asset_histories_assets. This is because rails convention requires the Join table
    # to be the pluralized version of both models, in alphabetical order. Also, they denote the underscore
    # as being before a letter, thus asset_ comes before assets. 
end
