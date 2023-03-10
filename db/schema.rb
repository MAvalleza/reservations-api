# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_01_174356) do
  create_table "guests", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.string "code"
    t.string "start_date"
    t.string "end_date"
    t.integer "nights"
    t.integer "guests"
    t.integer "adults"
    t.integer "children"
    t.integer "infants"
    t.string "status"
    t.string "currency"
    t.string "payout_price"
    t.string "security_price"
    t.string "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guest_id"
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
  end

  add_foreign_key "reservations", "guests"
end
