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

ActiveRecord::Schema.define(version: 20171211035724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "driver_locations", force: :cascade do |t|
    t.bigint "driver_id"
    t.bigint "order_id"
    t.string "service_type"
    t.text "location"
    t.decimal "lat"
    t.decimal "lng"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_driver_locations_on_driver_id"
    t.index ["order_id"], name: "index_driver_locations_on_order_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "service_type"
    t.decimal "credit", precision: 8, scale: 2, default: "50000.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "driver_id"
    t.text "origin"
    t.text "destination"
    t.decimal "distance"
    t.string "service_type"
    t.string "payment_type"
    t.decimal "price"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_orders_on_driver_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.decimal "credit", precision: 8, scale: 2, default: "50000.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
