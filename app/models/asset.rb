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

  before_save { |asset| asset.asset_symbol = asset_symbol.upcase }
  
  after_create :populatepricehistory

 
  
  private

  	def populatepricehistory
      numberofdays = 1000
      unless AssetHistory.find_by_asset_symbol(self.asset_symbol).nil?
          mostrecentdate = AssetHistory.find(:all, :select=>'date',:order=>'date DESC',:conditions=>{:asset_symbol=>self.asset_symbol},:limit=>1)
          numberofdays = (Date.today - mostrecentdate[0].date).to_i
      end

      prices = YahooFinance::get_historical_quotes_days(self.asset_symbol,numberofdays) 
    

      unless prices.empty?
        (0...prices.size-1).each do |n|
          percentchange = prices[n][4].to_f/prices[n+1][4].to_f-1
          prices[n].push(self.asset_symbol)
          prices[n].push(percentchange)
        end
        
        prices[-1].push(self.asset_symbol)
        prices[-1].push(nil)
    

        columns = [:date,:open,:high,:low,:close,:volume,:adjusted_close,:asset_symbol,:percent_change]
        AssetHistory.transaction do
          ActiveRecord::Base.connection.execute('LOCK TABLE asset_histories IN EXCLUSIVE MODE')
          AssetHistory.import columns,prices
        end

      end  

      assethistoryids = AssetHistory.find(:all, :select=>'id', :conditions=>{:asset_symbol=>self.asset_symbol})
      values = assethistoryids.map{|assethistory| "(#{self.id},#{assethistory.id})"}.join(",")
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute('LOCK TABLE asset_histories_assets IN EXCLUSIVE MODE')
        ActiveRecord::Base.connection.execute("WITH notinyet(asset_id,asset_history_id) AS (VALUES#{values}) INSERT INTO asset_histories_assets (asset_id,asset_history_id) SELECT * FROM notinyet WHERE NOT EXISTS(SELECT * FROM asset_histories_assets INNER JOIN notinyet ON asset_histories_assets.asset_id = #{self.id} AND asset_histories_assets.asset_history_id = notinyet.asset_history_id)")
      end
  	end

    # first we set the number of days of price history to 1000. This is the default.
    # We run a simple check to see if we already have the Asset in our AssetHistory table. 
    # If we do have it, we look for the most recent date that is in our database so that we only have to
    # update the difference in the dates. I.e. If we last updated it last month, we only need 30 days.
    # We set the numberofdays of price history to this difference.
    # If we don't have price history of the asset, then we default look for 1000 days of data.
    
    # prices = ... is the Yahoo Finance API which gets an array of data looking like 
    # {[date,open, close,high,low,volume,adjusted_close],[date2,open2,close2,high2,low2,volume2,adjusted_close2] etc.}
    # Next we check if prices.empty? to see if the data is up to date. If it is, we skip the whole populating price history
    # since we don't need to populate the price history.

    # If it isn't empty, the rest of the block runs...
    # We iterate through the prices to add the stock symbol to that array
    # We also add the percentage price difference between now and the previous day.

    # We will use activerecord-import gem to mass insert into the database.
    # Part of the mass insert requirements is to list the column names in an array
    # columns = ... is the name of the columns
    # notice that the prices variable is the values in the exact same order as the columns
    # AssetHistory.import columns,prices is the gem which mass imports the data into AssetHistory
    # ActiveRecord::Base.connection.execute is a command to execute SQL statements for the database. 
    # We send that statement to lock the table and prevent what is known as a concurrent modification
    # That is, if 2 people add a stock at the exact same time, then we would have 2x the stock price data
    # Locking the table prevents anyone from modifying it. Thus one of the people's actions would go first
    # and the second person would wait in line. Once the first person goes, the second person will try
    # and add the data, but then find that the data is now updated so there shouldn't be any concurrent modification
    # errors.
    # .transaction do is a way of telling Rails that we are modifying the database somehow, and to make sure
    # everything in the do / end block is performed. If anything raises an error, the entire transaction is cancelled.
    # The lock is lifted soon as the transaction is ended. 

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
    # As said before ActiveRecord::Base.connection.execute is a command to execute SQL statements.
    # In other words, we could open up our Postgres database and type that statement to have the commands
    # execute under that GUI. However since we won't always have the Postgres GUI, this is how ruby executes
    # the commands of an SQL statement

    # I use an SQL statement because SQL statements is a fast way to mass import and because
    # we are importing into the Join Table. I'm not sure if you can use the gem to import into the 
    # Join Table so this makes things easier. Notice the name of the join table is referenced in the 
    # SQL statement. It is asset_histories_assets. This is because rails convention requires the Join table
    # to be the pluralized version of both models, in alphabetical order. Also, they denote the underscore
    # as being before a letter, thus asset_ comes before assets. 

    # the SQL statement can be understood like:
    # the WITH statement is used to label what we are looking at. By giving it a name we can reference it later.
    # In this case I named the values 'notinyet' and wrote (asset_id,asset_history_id) AS VALUES.
    # This makes it so that asset_id is associated with the first value and asset_history_id with the second.
    # I then use the 'INSERT INTO tablename' to denote the table I will be inserting into.
    # Next I choose the values. Normally you can type INSERT INTO tablename VALUES values, but in this case
    # we needed to check everything we were inserting. Thus we can't use that easier syntax. 
    # After denoting the table we INSERT INTO, we need to denote the values we will take.
    # Because we can't use the easier syntax, we now make use of the WITH statement we used earlier.
    # We SELECT * FROM notinyet. Which is to say we take everything from that table. Remember that table
    # was just the values which is what we need. Next we use the WHERE statement which determines an action
    # based on if it evaluates to true. In this case, true results in the value being inserted.
    # If it is false, then it is not inserted. EXISTS is the next command, a boolean which tests whether
    # a query evaluates to true. Inside the EXISTS, we run a query to SELECT * FROM asset_histories_assets table
    # INNER JOIN notinyet ON (condition)...INNER JOIN allows the query to also look at data from a second table. We need 
    # this to check if the first table's id is equal to the second table's id. I.e. in the condition, the asset_id has to equal 
    # the asset id we are currently adding and the asset_history_id has to equal the same asset_history_id as the notinyet.asset_history_id value. 
    # If this is true, then what the 'notinyet' (what we are trying to add) is actually in the asset_histories_assets table. 
    # Therefore Exists will evaluate to TRUE which means NOT EXISTS will evaluate to FALSE. 
    # Thus WHERE NOT EXISTS evaluates to FALSE and the INSERT is skipped when what we are adding is already in the asset_histories_assets table.
    # Thus only when we can't find it in our table, does it get added. Thus no duplicates are created and 
    # we don't get an error for duplicates.
    
end
