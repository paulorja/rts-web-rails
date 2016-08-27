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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160827203547) do

  create_table "battles", force: :cascade do |t|
    t.integer  "user_from_id", limit: 4
    t.integer  "user_to_id",   limit: 4
    t.integer  "cell_to_id",   limit: 4
    t.text     "battle_data",  limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "cell_units", force: :cascade do |t|
    t.integer "cell_id", limit: 4
    t.integer "user_id", limit: 4
    t.integer "unit",    limit: 4
    t.boolean "hurt",                default: false
    t.string  "name",    limit: 255
  end

  create_table "cells", force: :cascade do |t|
    t.integer "x",              limit: 4
    t.integer "y",              limit: 4
    t.integer "terrain_code",   limit: 4,   default: 0
    t.string  "terrain_sprite", limit: 255
    t.integer "building_code",  limit: 4,   default: 0
    t.integer "building_level", limit: 4,   default: 0
    t.integer "user_id",        limit: 4,   default: 0
    t.string  "villagers",      limit: 255
    t.boolean "idle",                       default: true
    t.boolean "battle",                     default: true
  end

  add_index "cells", ["x", "y"], name: "x", using: :btree

  create_table "event_battles", force: :cascade do |t|
    t.integer "user_from_id", limit: 4
    t.integer "user_to_id",   limit: 4
    t.integer "cell_id",      limit: 4
    t.integer "battle_id",    limit: 4
  end

  create_table "event_blacksmiths", force: :cascade do |t|
    t.integer "event_id",  limit: 4
    t.integer "user_id",   limit: 4
    t.string  "up_column", limit: 255
  end

  create_table "event_building_destroys", force: :cascade do |t|
    t.integer "event_id", limit: 4
    t.integer "cell_id",  limit: 4
  end

  create_table "event_building_ups", force: :cascade do |t|
    t.integer "event_id", limit: 4
    t.integer "cell_id",  limit: 4
  end

  create_table "event_market_offers", force: :cascade do |t|
    t.integer "event_id",        limit: 4
    t.integer "market_offer_id", limit: 4
  end

  create_table "event_new_units", force: :cascade do |t|
    t.integer "event_id", limit: 4
    t.integer "cell_id",  limit: 4
    t.integer "user_id",  limit: 4
    t.integer "unit",     limit: 4
  end

  create_table "event_to_grasses", force: :cascade do |t|
    t.integer "event_id", limit: 4
    t.integer "cell_id",  limit: 4
    t.integer "user_id",  limit: 4
  end

  create_table "events", force: :cascade do |t|
    t.integer "start_time", limit: 4
    t.integer "end_time",   limit: 4
    t.integer "event_type", limit: 4
  end

  create_table "market_offers", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "return_user_id",  limit: 4
    t.string   "offer_recourse",  limit: 255
    t.string   "return_recourse", limit: 255
    t.integer  "offer_amount",    limit: 4
    t.integer  "return_amount",   limit: 4
    t.integer  "status",          limit: 4
    t.integer  "arrivet_at",      limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "report_battles", force: :cascade do |t|
    t.integer  "report_id",  limit: 4
    t.integer  "battle_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "report_market_offers", force: :cascade do |t|
    t.integer  "report_id",       limit: 4
    t.integer  "market_offer_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "user_2_id",   limit: 4
    t.integer  "report_type", limit: 4
    t.boolean  "read"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "user_data", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.float    "wood",              limit: 24,  default: 0.0
    t.float    "gold",              limit: 24,  default: 0.0
    t.float    "food",              limit: 24,  default: 0.0
    t.float    "stone",             limit: 24,  default: 0.0
    t.integer  "wood_villagers",    limit: 4,   default: 0
    t.integer  "gold_villagers",    limit: 4,   default: 0
    t.integer  "food_villagers",    limit: 4,   default: 0
    t.integer  "stone_villagers",   limit: 4,   default: 0
    t.integer  "storage",           limit: 4,   default: 0
    t.integer  "total_roads",       limit: 4,   default: 0
    t.integer  "max_roads",         limit: 4,   default: 0
    t.integer  "total_pop",         limit: 4,   default: 0
    t.integer  "max_pop",           limit: 4,   default: 0
    t.integer  "total_territories", limit: 4,   default: 0
    t.integer  "score",             limit: 4,   default: 0
    t.integer  "new_reports",       limit: 4,   default: 0
    t.integer  "new_message",       limit: 4,   default: 0
    t.integer  "blacksmith_hoe",    limit: 4,   default: 0
    t.integer  "blacksmith_axe",    limit: 4,   default: 0
    t.integer  "blacksmith_pick",   limit: 4,   default: 0
    t.string   "last_update",       limit: 255
    t.boolean  "have_market"
    t.boolean  "have_blacksmith"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "user_data", ["user_id"], name: "index_user_data_on_user_id", using: :btree

  create_table "user_messages", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "body",         limit: 65535
    t.integer  "from_user_id", limit: 4
    t.integer  "to_user_id",   limit: 4
    t.boolean  "read"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",      limit: 255
    t.string   "email",      limit: 255
    t.string   "password",   limit: 255
    t.integer  "user_type",  limit: 4
    t.integer  "castle_x",   limit: 4
    t.integer  "castle_y",   limit: 4
    t.string   "color",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "user_data", "users"
end
