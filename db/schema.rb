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

ActiveRecord::Schema.define(version: 20170818120917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.integer  "id_steama",               null: false
    t.string   "url"
    t.string   "transactions_url"
    t.string   "utilities"
    t.string   "telephone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "account_balance"
    t.string   "low_balance_warning"
    t.string   "low_balance_level"
    t.integer  "site_manager"
    t.string   "site_manager_url"
    t.string   "site_manager_telephone"
    t.integer  "site"
    t.string   "site_url"
    t.string   "site_name"
    t.integer  "bit_harvester"
    t.string   "bit_harvester_url"
    t.string   "bit_harvester_telephone"
    t.string   "control_type"
    t.string   "line_number"
    t.boolean  "is_user"
    t.boolean  "is_agent"
    t.boolean  "is_site_manager"
    t.boolean  "is_field_manager"
    t.boolean  "is_demo"
    t.string   "language"
    t.string   "TOU_hours"
    t.string   "payment_plan"
    t.string   "integration_id"
    t.string   "labels"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "recordings", force: :cascade do |t|
    t.string   "data",                    null: false
    t.text     "array_data", default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "file"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "admin",                             default: false, null: false
    t.string   "authentication_token",   limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
