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

ActiveRecord::Schema.define(version: 20160424074418) do

  create_table "atms", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.float    "lat"
    t.float    "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "text"
    t.boolean  "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "fb_id"
    t.string   "email"
    t.string   "bank_id"
    t.string   "account_id"
    t.integer  "pin"
    t.string   "state"
    t.boolean  "clear_state"
    t.integer  "rating"
    t.float    "location_lat"
    t.float    "location_long"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
