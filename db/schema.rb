# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130331081157) do

  create_table "asset_histories", :force => true do |t|
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.float   "adjusted_close"
    t.string  "asset_symbol"
  end

  add_index "asset_histories", ["asset_symbol"], :name => "index_asset_histories_on_asset_symbol"
  add_index "asset_histories", ["date", "asset_symbol"], :name => "index_asset_histories_on_date_and_asset_symbol", :unique => true

  create_table "asset_histories_assets", :id => false, :force => true do |t|
    t.integer "asset_id"
    t.integer "asset_history_id"
  end

  add_index "asset_histories_assets", ["asset_id", "asset_history_id"], :name => "index_asset_histories_assets_on_asset_id_and_asset_history_id", :unique => true

  create_table "assets", :force => true do |t|
    t.string   "asset_symbol"
    t.float    "shares"
    t.float    "cost"
    t.date     "purchase_date"
    t.integer  "portfolio_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "portfolios", :force => true do |t|
    t.string   "portfolio_name"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
