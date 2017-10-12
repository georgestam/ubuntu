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

ActiveRecord::Schema.define(version: 20171010083148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "type_alert_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "status_id"
    t.string   "resolved_comments"
    t.datetime "resolved_at"
    t.datetime "closed_at"
    t.integer  "issue_id"
    t.integer  "created_by_id"
    t.integer  "user_id"
    t.index ["customer_id"], name: "index_alerts_on_customer_id", using: :btree
    t.index ["issue_id"], name: "index_alerts_on_issue_id", using: :btree
    t.index ["status_id"], name: "index_alerts_on_status_id", using: :btree
    t.index ["type_alert_id"], name: "index_alerts_on_type_alert_id", using: :btree
  end

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
    t.string   "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "group_alerts", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_group_alerts_on_user_id", using: :btree
  end

  create_table "issues", force: :cascade do |t|
    t.integer  "type_alert_id"
    t.string   "resolution"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["type_alert_id"], name: "index_issues_on_type_alert_id", using: :btree
  end

  create_table "meters", force: :cascade do |t|
    t.integer  "customer_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_meters_on_customer_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topups", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "amount"
    t.integer  "id_steama"
    t.datetime "created_on",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_topups_on_customer_id", using: :btree
  end

  create_table "type_alerts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "group_alert_id"
    t.index ["group_alert_id"], name: "index_type_alerts_on_group_alert_id", using: :btree
  end

  create_table "usages", force: :cascade do |t|
    t.text     "api_data",   null: false
    t.date     "created_on", null: false
    t.integer  "meter_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meter_id", "created_on"], name: "index_usages_on_meter_id_and_created_on", unique: true, using: :btree
    t.index ["meter_id"], name: "index_usages_on_meter_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",           null: false
    t.string   "encrypted_password",                default: "",           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "admin",                             default: false,        null: false
    t.string   "authentication_token",   limit: 30
    t.string   "role",                              default: "field_user"
    t.string   "name"
    t.string   "slack_username"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "alerts", "customers"
  add_foreign_key "alerts", "issues"
  add_foreign_key "alerts", "statuses"
  add_foreign_key "alerts", "type_alerts"
  add_foreign_key "alerts", "users"
  add_foreign_key "alerts", "users", column: "created_by_id"
  add_foreign_key "group_alerts", "users"
  add_foreign_key "issues", "type_alerts"
  add_foreign_key "meters", "customers"
  add_foreign_key "topups", "customers"
  add_foreign_key "type_alerts", "group_alerts"
  add_foreign_key "usages", "meters"
end
