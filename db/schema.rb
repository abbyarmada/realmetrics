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

ActiveRecord::Schema.define(version: 20160606135352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "goals", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "year"
    t.integer  "month"
    t.string   "metric"
    t.integer  "value"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "goals", ["organization_id", "year", "month", "metric"], name: "idx_uk_goals", unique: true, using: :btree
  add_index "goals", ["organization_id"], name: "index_goals_on_organization_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "publishable_key"
    t.string   "token"
    t.string   "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "identities", ["organization_id", "provider", "uid"], name: "idx_uk_identities", unique: true, using: :btree
  add_index "identities", ["organization_id"], name: "index_identities_on_organization_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "initial_crawl_completed", default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "organizations", ["user_id"], name: "index_organizations_on_user_id", using: :btree

  create_table "stripe_coupons", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "guid"
    t.string   "provider"
    t.datetime "created_at"
    t.integer  "amount_off"
    t.string   "currency"
    t.string   "duration"
    t.integer  "duration_in_months"
    t.integer  "max_redemptions"
    t.integer  "percent_off"
    t.integer  "redeem_by"
    t.integer  "times_redeemed"
    t.boolean  "active"
  end

  add_index "stripe_coupons", ["organization_id", "guid", "provider"], name: "idx_uk_stripe_coupons", unique: true, using: :btree
  add_index "stripe_coupons", ["organization_id"], name: "index_stripe_coupons_on_organization_id", using: :btree

  create_table "stripe_customers", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "guid"
    t.string   "provider"
    t.string   "email"
    t.integer  "account_balance"
    t.datetime "created_at"
    t.string   "currency"
    t.boolean  "delinquent"
  end

  add_index "stripe_customers", ["organization_id", "guid", "provider"], name: "idx_uk_stripe_customers", unique: true, using: :btree
  add_index "stripe_customers", ["organization_id"], name: "index_stripe_customers_on_organization_id", using: :btree

  create_table "stripe_discounts", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "provider"
    t.string   "coupon_guid"
    t.string   "customer_guid"
    t.string   "subscription_guid"
    t.datetime "started_at"
    t.datetime "ended_at"
  end

  add_index "stripe_discounts", ["organization_id", "provider", "coupon_guid", "customer_guid", "subscription_guid"], name: "idx_uk_stripe_discounts", unique: true, using: :btree
  add_index "stripe_discounts", ["organization_id"], name: "index_stripe_discounts_on_organization_id", using: :btree

  create_table "stripe_events", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "guid"
    t.string   "provider"
    t.datetime "created_at"
    t.string   "event_type"
    t.text     "event_data"
  end

  add_index "stripe_events", ["organization_id", "guid", "provider"], name: "idx_uk_stripe_events", unique: true, using: :btree
  add_index "stripe_events", ["organization_id"], name: "index_stripe_events_on_organization_id", using: :btree

  create_table "stripe_plans", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "guid"
    t.string   "provider"
    t.string   "name"
    t.string   "statement_descriptor"
    t.integer  "trial_period_days"
    t.datetime "created_at"
    t.integer  "amount"
    t.string   "currency"
    t.string   "interval"
    t.integer  "interval_count"
  end

  add_index "stripe_plans", ["organization_id", "guid", "provider"], name: "idx_uk_stripe_plans", unique: true, using: :btree
  add_index "stripe_plans", ["organization_id"], name: "index_stripe_plans_on_organization_id", using: :btree

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "guid"
    t.string   "provider"
    t.string   "customer_guid"
    t.string   "plan_guid"
    t.datetime "created_at"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "trial_started_at"
    t.datetime "trial_ended_at"
    t.string   "status"
    t.integer  "quantity"
    t.decimal  "tax_percent"
    t.boolean  "cancel_at_period_end"
    t.datetime "canceled_at"
    t.datetime "current_period_end_at"
    t.datetime "current_period_started_at"
  end

  add_index "stripe_subscriptions", ["organization_id", "guid", "provider"], name: "idx_uk_stripe_subscriptions", unique: true, using: :btree
  add_index "stripe_subscriptions", ["organization_id"], name: "index_stripe_subscriptions_on_organization_id", using: :btree

  create_table "stripe_transactions", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "guid"
    t.string   "provider"
    t.datetime "created_at"
    t.string   "currency"
    t.integer  "gross_amount"
    t.integer  "fee_amount"
    t.integer  "net_amount"
    t.string   "transaction_type"
  end

  add_index "stripe_transactions", ["organization_id", "guid", "provider"], name: "idx_uk_stripe_transactions", unique: true, using: :btree
  add_index "stripe_transactions", ["organization_id"], name: "index_stripe_transactions_on_organization_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count",          default: 0, null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_foreign_key "goals", "organizations"
  add_foreign_key "identities", "organizations"
  add_foreign_key "organizations", "users"
  add_foreign_key "stripe_coupons", "organizations"
  add_foreign_key "stripe_customers", "organizations"
  add_foreign_key "stripe_discounts", "organizations"
  add_foreign_key "stripe_events", "organizations"
  add_foreign_key "stripe_plans", "organizations"
  add_foreign_key "stripe_subscriptions", "organizations"
  add_foreign_key "stripe_transactions", "organizations"
end
