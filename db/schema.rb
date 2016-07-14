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

ActiveRecord::Schema.define(version: 20160708015800) do

  create_table "cells", force: :cascade do |t|
    t.integer "x",              limit: 4
    t.integer "y",              limit: 4
    t.integer "terrain_code",   limit: 4,   default: 0
    t.integer "building_code",  limit: 4,   default: 0
    t.integer "building_level", limit: 4,   default: 0
    t.integer "user_id",        limit: 4,   default: 0
    t.string  "villagers",      limit: 255
    t.boolean "idle",                       default: true
  end

  create_table "event_building_ups", force: :cascade do |t|
    t.integer "event_id", limit: 4
    t.integer "cell_id",  limit: 4
  end

  create_table "events", force: :cascade do |t|
    t.integer "start_time", limit: 4
    t.integer "end_time",   limit: 4
    t.integer "event_type", limit: 4
  end

  create_table "user_data", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "wood",            limit: 4,   default: 0
    t.integer  "gold",            limit: 4,   default: 0
    t.integer  "food",            limit: 4,   default: 0
    t.integer  "stone",           limit: 4,   default: 0
    t.integer  "storage",         limit: 4,   default: 0
    t.integer  "idle_villagers",  limit: 4,   default: 0
    t.integer  "total_villagers", limit: 4,   default: 0
    t.string   "last_update",     limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "user_data", ["user_id"], name: "index_user_data_on_user_id", using: :btree

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
