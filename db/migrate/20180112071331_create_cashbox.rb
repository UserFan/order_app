class CreateCashbox < ActiveRecord::Migration[5.1]
  def change
    create_table :cashboxes do |t|
      t.integer  :shop_id,                 null: false, default: 0
      t.integer  :display_id,              null: false, default: 0
      t.string   :display_sn
      t.integer  :system_unit_id,          null: false, default: 0
      t.string   :system_unit_sn
      t.integer  :keyboard_id,             null: false, default: 0
      t.string   :keyboard_sn
      t.integer  :display_client_id,       null: false, default: 0
      t.string   :display_client_sn
      t.integer  :stabilizer_id,           null: false, default: 0
      t.string   :stabilizer_sn
      t.integer  :apc_id,                  null: false, default: 0
      t.string   :apc_sn
      t.integer  :scaner_id,               null: false, default: 0
      t.string   :scaner_sn
      t.integer  :bank_unit_id,            null: false, default: 0
      t.string   :terminal_sn
      t.integer  :fiscal_id,               null: false, default: 0
      t.string   :fiscal_sn
      t.integer  :organozation_unit_id,    null: false, default: 0
      t.string   :comment
      t.integer  :cashbox_photos_id,       null: false, default: 0
      t.timestamps
    end
    add_index :cashboxes, :shop_id
    add_index :cashboxes, :display_id
    add_index :cashboxes, :keyboard_id
    add_index :cashboxes, :system_unit_id
    add_index :cashboxes, :display_client_id
    add_index :cashboxes, :stabilizer_id
    add_index :cashboxes, :apc_id
    add_index :cashboxes, :scaner_id
    add_index :cashboxes, :bank_unit_id
    add_index :cashboxes, :fiscal_id
    add_index :cashboxes, :organozation_unit_id
    add_index :cashboxes, :cashbox_photos_id
  end
end
