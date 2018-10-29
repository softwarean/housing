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

ActiveRecord::Schema.define(version: 20171031092646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "account_number", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "apartment_id",   null: false
    t.index ["account_number"], name: "index_accounts_on_account_number", unique: true, using: :btree
    t.index ["apartment_id"], name: "index_accounts_on_apartment_id", using: :btree
  end

  create_table "apartments", force: :cascade do |t|
    t.integer  "house_id",   null: false
    t.integer  "number",     null: false
    t.decimal  "total_area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id", "number"], name: "index_apartments_on_house_id_and_number", unique: true, using: :btree
    t.index ["house_id"], name: "index_apartments_on_house_id", using: :btree
  end

  create_table "appeals", force: :cascade do |t|
    t.text     "content",    null: false
    t.string   "aasm_state"
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_appeals_on_user_id", using: :btree
  end

  create_table "claims", force: :cascade do |t|
    t.string   "subject"
    t.text     "description"
    t.integer  "service_id",  null: false
    t.integer  "user_id",     null: false
    t.datetime "deadline"
    t.string   "aasm_state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["service_id"], name: "index_claims_on_service_id", using: :btree
    t.index ["user_id"], name: "index_claims_on_user_id", using: :btree
  end

  create_table "houses", force: :cascade do |t|
    t.integer  "street_id",    null: false
    t.string   "house_number", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["street_id", "house_number"], name: "index_houses_on_street_id_and_house_number", unique: true, using: :btree
    t.index ["street_id"], name: "index_houses_on_street_id", using: :btree
  end

  create_table "meter_indications", force: :cascade do |t|
    t.string   "meter_uuid",        null: false
    t.string   "meter_description"
    t.datetime "transmitted_at",    null: false
    t.jsonb    "data"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["created_at"], name: "index_meter_indications_on_created_at", using: :btree
    t.index ["meter_uuid"], name: "index_meter_indications_on_meter_uuid", using: :btree
    t.index ["transmitted_at"], name: "index_meter_indications_on_transmitted_at", using: :btree
  end

  create_table "meters", force: :cascade do |t|
    t.string   "uuid",           null: false
    t.string   "description"
    t.string   "number"
    t.string   "kind",           null: false
    t.string   "account_number"
    t.string   "street"
    t.string   "house"
    t.string   "apartment"
    t.string   "floor"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "house_id"
    t.index ["house_id"], name: "index_meters_on_house_id", using: :btree
    t.index ["uuid"], name: "index_meters_on_uuid", unique: true, using: :btree
  end

  create_table "reduced_indications", force: :cascade do |t|
    t.integer  "meter_id"
    t.date     "date",         null: false
    t.integer  "hour",         null: false
    t.integer  "last_total",   null: false
    t.integer  "last_daily"
    t.integer  "last_nightly"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["date"], name: "index_reduced_indications_on_date", using: :btree
    t.index ["meter_id", "date", "hour"], name: "index_reduced_indications_on_meter_id_and_date_and_hour", unique: true, using: :btree
    t.index ["meter_id"], name: "index_reduced_indications_on_meter_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "name",       null: false
    t.decimal  "cost",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "streets", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tariffs", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "unit_of_measure", null: false
    t.decimal  "value",           null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "kind"
  end

  create_table "user_map_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_user_map_accounts_on_account_id", using: :btree
    t.index ["user_id"], name: "index_user_map_accounts_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "role"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "phone",           null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "accounts", "apartments"
  add_foreign_key "apartments", "houses"
  add_foreign_key "appeals", "users"
  add_foreign_key "claims", "services"
  add_foreign_key "claims", "users"
  add_foreign_key "houses", "streets"
  add_foreign_key "meters", "houses"
  add_foreign_key "reduced_indications", "meters"
  add_foreign_key "user_map_accounts", "accounts"
  add_foreign_key "user_map_accounts", "users"
end
