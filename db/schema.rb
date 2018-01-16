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

ActiveRecord::Schema.define(version: 20180116073321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apcs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bank_units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cashboxes", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "display_id", default: 0, null: false
    t.string "display_sn"
    t.bigint "system_unit_id", default: 0, null: false
    t.string "system_unit_sn"
    t.bigint "keyboard_id", default: 0, null: false
    t.string "keyboard_sn"
    t.integer "display_client_id", default: 0, null: false
    t.string "display_client_sn"
    t.bigint "stabilizer_id", default: 0, null: false
    t.string "stabilizer_sn"
    t.bigint "apc_id", default: 0, null: false
    t.string "apc_sn"
    t.bigint "scaner_id", default: 0, null: false
    t.string "scaner_sn"
    t.bigint "bank_unit_id", default: 0, null: false
    t.string "terminal_sn"
    t.bigint "fiscal_id", default: 0, null: false
    t.string "fiscal_sn"
    t.bigint "organization_unit_id", default: 0, null: false
    t.string "comment"
    t.integer "cashbox_photos_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apc_id"], name: "index_cashboxes_on_apc_id"
    t.index ["bank_unit_id"], name: "index_cashboxes_on_bank_unit_id"
    t.index ["cashbox_photos_id"], name: "index_cashboxes_on_cashbox_photos_id"
    t.index ["display_client_id"], name: "index_cashboxes_on_display_client_id"
    t.index ["display_id"], name: "index_cashboxes_on_display_id"
    t.index ["fiscal_id"], name: "index_cashboxes_on_fiscal_id"
    t.index ["keyboard_id"], name: "index_cashboxes_on_keyboard_id"
    t.index ["organization_unit_id"], name: "index_cashboxes_on_organization_unit_id"
    t.index ["scaner_id"], name: "index_cashboxes_on_scaner_id"
    t.index ["shop_id"], name: "index_cashboxes_on_shop_id"
    t.index ["stabilizer_id"], name: "index_cashboxes_on_stabilizer_id"
    t.index ["system_unit_id"], name: "index_cashboxes_on_system_unit_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commouses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communications", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "displays", force: :cascade do |t|
    t.string "name"
  end

  create_table "fiscals", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keyboards", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modems", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "category_id", default: 0, null: false
    t.datetime "date_open", null: false
    t.integer "shop_id", default: 0, null: false
    t.string "short_descript", default: "", null: false
    t.text "description"
    t.datetime "date_closed"
    t.integer "user_id", default: 0, null: false
    t.integer "status_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "photos"
    t.datetime "date_execution"
    t.index ["category_id"], name: "index_orders_on_category_id"
    t.index ["shop_id"], name: "index_orders_on_shop_id"
    t.index ["status_id"], name: "index_orders_on_status_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "organization_units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "printers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scaleses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scaners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "address", default: "", null: false
    t.string "gps", default: "", null: false
    t.integer "type_id", default: 0, null: false
    t.string "photo"
    t.integer "user_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "closed"
    t.index ["type_id"], name: "index_shops_on_type_id"
    t.index ["user_id"], name: "index_shops_on_user_id"
  end

  create_table "stabilizers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_units", force: :cascade do |t|
    t.string "cpu"
    t.string "ram"
    t.string "motherboard"
    t.string "hdd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "os"
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "mobile", default: "", null: false
    t.integer "position_id", default: 0, null: false
    t.integer "role_id", default: 1, null: false
    t.boolean "admin", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["position_id"], name: "index_users_on_position_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "weighers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
