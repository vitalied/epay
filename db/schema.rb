# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_14_174437) do

  create_table "merchants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "email", null: false
    t.string "status", limit: 10, null: false
    t.decimal "total_transaction_sum", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_merchants_on_email", unique: true
    t.index ["name"], name: "index_merchants_on_name", unique: true
    t.index ["status"], name: "index_merchants_on_status"
    t.index ["user_id"], name: "index_merchants_on_user_id"
  end

  create_table "transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "type", limit: 20, null: false
    t.bigint "merchant_id", null: false
    t.string "reference_uuid", limit: 50
    t.string "uuid", limit: 50, null: false
    t.decimal "amount", precision: 12, scale: 2
    t.string "status", limit: 20, null: false
    t.string "customer_email", null: false
    t.string "customer_phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_transactions_on_merchant_id"
    t.index ["reference_uuid"], name: "index_transactions_on_reference_uuid"
    t.index ["status"], name: "index_transactions_on_status"
    t.index ["type"], name: "index_transactions_on_type"
    t.index ["uuid"], name: "index_transactions_on_uuid", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "authentication_token", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "merchants", "users"
  add_foreign_key "transactions", "merchants"
  add_foreign_key "transactions", "transactions", column: "reference_uuid", primary_key: "uuid", name: "index_transactions_on_reference_uuid"
end
