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

ActiveRecord::Schema[7.2].define(version: 2024_08_15_003523) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "report_status", ["processing", "avaiable", "failed"]

  create_table "invoices", force: :cascade do |t|
    t.integer "serie"
    t.bigint "number"
    t.datetime "emitted_at"
    t.decimal "total_icms", precision: 10, scale: 2
    t.decimal "total_ipi", precision: 10, scale: 2
    t.decimal "total_pis", precision: 10, scale: 2
    t.decimal "total_cofins", precision: 10, scale: 2
    t.hstore "total_values"
    t.bigint "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_invoices_on_report_id"
  end

  create_table "issuers", force: :cascade do |t|
    t.string "cnpj"
    t.string "name"
    t.string "fantasy_name"
    t.string "neighborhood"
    t.string "address_street"
    t.integer "address_number"
    t.string "address_complement"
    t.string "city_code"
    t.string "city"
    t.string "country_code"
    t.string "country"
    t.string "postal_code"
    t.string "state"
    t.string "phone_number"
    t.string "state_subscription"
    t.string "tax_regime_code"
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_issuers_on_invoice_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "ncm"
    t.string "cfop"
    t.string "unity_commercialized"
    t.integer "quantity_commercialized"
    t.string "unity_value"
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_products_on_invoice_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.string "cnpj"
    t.string "name"
    t.string "fantasy_name"
    t.string "neighborhood"
    t.string "address_street"
    t.integer "address_number"
    t.string "address_complement"
    t.string "city_code"
    t.string "city"
    t.string "country_code"
    t.string "country"
    t.string "postal_code"
    t.string "state"
    t.string "phone_number"
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_recipients_on_invoice_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "title"
    t.enum "status", default: "processing", null: false, enum_type: "report_status"
    t.string "failure_reason"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
