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

ActiveRecord::Schema.define(version: 20190123085628) do

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

  create_table "carrier_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_images", force: :cascade do |t|
    t.bigint "cashbox_id", default: 0, null: false
    t.datetime "date_add", null: false
    t.jsonb "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cashbox_id"], name: "index_cash_images_on_cashbox_id"
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
    t.string "fiscal_fwversion", default: ""
    t.string "cash_set_version", default: ""
    t.string "ip_cash", default: ""
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

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
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

  create_table "computers", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.bigint "display_id", default: 0, null: false
    t.string "display_sn"
    t.bigint "system_unit_id", default: 0, null: false
    t.string "system_unit_sn"
    t.bigint "keyboard_id", default: 0, null: false
    t.string "keyboard_sn"
    t.bigint "commouse_id", default: 0, null: false
    t.string "commouse_sn"
    t.bigint "stabilizer_id", default: 0, null: false
    t.string "stabilizer_sn"
    t.bigint "printer_id", default: 0, null: false
    t.string "printer_sn"
    t.string "teamview_id", default: "", null: false
    t.string "ip_address", default: "", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commouse_id"], name: "index_computers_on_commouse_id"
    t.index ["display_id"], name: "index_computers_on_display_id"
    t.index ["keyboard_id"], name: "index_computers_on_keyboard_id"
    t.index ["printer_id"], name: "index_computers_on_printer_id"
    t.index ["shop_id"], name: "index_computers_on_shop_id"
    t.index ["stabilizer_id"], name: "index_computers_on_stabilizer_id"
    t.index ["system_unit_id"], name: "index_computers_on_system_unit_id"
  end

  create_table "cost_equipments", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.bigint "cost_type_id", default: 0, null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_cost", null: false
    t.index ["cost_type_id"], name: "index_cost_equipments_on_cost_type_id"
    t.index ["shop_id"], name: "index_cost_equipments_on_shop_id"
  end

  create_table "cost_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "displays", force: :cascade do |t|
    t.string "name"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.bigint "user_id", default: 0, null: false
    t.datetime "work_start_date", null: false
    t.datetime "work_end_date"
    t.boolean "manager", default: false, null: false
    t.boolean "temporary", default: false, null: false
    t.bigint "position_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_id"], name: "index_employees_on_position_id"
    t.index ["shop_id"], name: "index_employees_on_shop_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "equipment_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "esp_certs", force: :cascade do |t|
    t.bigint "esp_id", default: 0, null: false
    t.datetime "date_start_esp", null: false
    t.datetime "date_end_esp", null: false
    t.string "serial_num_esp"
    t.datetime "date_start_rsa", null: false
    t.datetime "date_end_rsa", null: false
    t.string "rsa_serial"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["esp_id"], name: "index_esp_certs_on_esp_id"
  end

  create_table "esps", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.bigint "carrier_type_id", default: 0, null: false
    t.string "kpp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_type_id"], name: "index_esps_on_carrier_type_id"
    t.index ["shop_id"], name: "index_esps_on_shop_id"
  end

  create_table "executions", force: :cascade do |t|
    t.bigint "performer_id", default: 0, null: false
    t.string "comment", default: "", null: false
    t.integer "order_execution", default: 0, null: false
    t.jsonb "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "completed"
    t.index ["performer_id"], name: "index_executions_on_performer_id"
  end

  create_table "fiscals", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_communications", force: :cascade do |t|
    t.bigint "shop_communication_id", default: 0, null: false
    t.bigint "communication_id", default: 0, null: false
    t.bigint "provider_id", default: 0, null: false
    t.bigint "modem_id", default: 0
    t.string "modem_sn"
    t.boolean "master", default: false
    t.string "login_name", default: ""
    t.string "pass_name", default: ""
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sim_card_id"
    t.index ["communication_id"], name: "index_item_communications_on_communication_id"
    t.index ["modem_id"], name: "index_item_communications_on_modem_id"
    t.index ["provider_id"], name: "index_item_communications_on_provider_id"
    t.index ["shop_communication_id"], name: "index_item_communications_on_shop_communication_id"
    t.index ["sim_card_id"], name: "index_item_communications_on_sim_card_id"
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
    t.text "description"
    t.datetime "date_closed"
    t.integer "user_id", default: 0, null: false
    t.integer "status_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "photos"
    t.datetime "date_execution"
    t.string "order_number", default: "", null: false
    t.bigint "employee_id"
    t.index ["category_id"], name: "index_orders_on_category_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["shop_id"], name: "index_orders_on_shop_id"
    t.index ["status_id"], name: "index_orders_on_status_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "organization_units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performers", force: :cascade do |t|
    t.bigint "order_id", default: 0, null: false
    t.boolean "message", default: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id", default: 0, null: false
    t.boolean "answerable", default: false, null: false
    t.datetime "deadline", null: false
    t.integer "rating_average", default: 0, null: false
    t.integer "hard_ratio_average", default: 1, null: false
    t.index ["employee_id"], name: "index_performers_on_employee_id"
    t.index ["order_id"], name: "index_performers_on_order_id"
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

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", default: 0, null: false
    t.string "surname", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "middle_name", default: ""
    t.string "avatar"
    t.string "mobile", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_recruitment"
    t.datetime "date_quit"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reworks", force: :cascade do |t|
    t.bigint "execution_id", default: 0, null: false
    t.bigint "user_id", default: 0, null: false
    t.string "comment", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["execution_id"], name: "index_reworks_on_execution_id"
    t.index ["user_id"], name: "index_reworks_on_user_id"
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

  create_table "service_equipments", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.bigint "equipment_type_id", default: 0, null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_service", null: false
    t.index ["equipment_type_id"], name: "index_service_equipments_on_equipment_type_id"
    t.index ["shop_id"], name: "index_service_equipments_on_shop_id"
  end

  create_table "shop_communications", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.bigint "router_id", default: 0, null: false
    t.string "router_sn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_communications_count", default: 0
    t.index ["router_id"], name: "index_shop_communications_on_router_id"
    t.index ["shop_id"], name: "index_shop_communications_on_shop_id"
  end

  create_table "shop_weighers", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.bigint "weigher_id", default: 0, null: false
    t.string "weigher_sn"
    t.string "ip_address", default: "", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_weighers_on_shop_id"
    t.index ["weigher_id"], name: "index_shop_weighers_on_weigher_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "address", default: "", null: false
    t.integer "type_id", default: 0, null: false
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "closed"
    t.string "email"
    t.integer "orders_count", default: 0
    t.integer "cashboxes_count", default: 0
    t.integer "computers_count", default: 0
    t.integer "shop_weighers_count", default: 0
    t.integer "shop_communications_count", default: 0
    t.boolean "structural_unit", default: false
    t.boolean "orders_take", default: false
    t.index ["type_id"], name: "index_shops_on_type_id"
  end

  create_table "sim_cards", force: :cascade do |t|
    t.string "simphone_number", default: ""
    t.string "sim_number", default: ""
    t.bigint "provider_id", default: 0, null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_sim_cards_on_provider_id"
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
    t.integer "role", array: true
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
    t.integer "orders_count", default: 0
    t.integer "shops_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "version_update_logs", force: :cascade do |t|
    t.bigint "shop_id", default: 0, null: false
    t.datetime "date_log", null: false
    t.boolean "result_update", default: false
    t.string "text_log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_version_update_logs_on_shop_id"
  end

  create_table "weighers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "item_communications", "sim_cards"
  add_foreign_key "orders", "employees"
  add_foreign_key "performers", "employees"
end
