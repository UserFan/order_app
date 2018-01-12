class CreateCashbox < ActiveRecord::Migration[5.1]
  def change
    create_table :cashboxes do |t|
      t.references  :shop,                 null: false, default: 0
      t.references :display,               null: false, default: 0
      t.string   :display_sn
      t.references  :system_unit,           null: false, default: 0
      t.string   :system_unit_sn
      t.references  :keyboard,             null: false, default: 0
      t.string   :keyboard_sn
      t.integer  :display_client_id,       null: false, default: 0
      t.string   :display_client_sn
      t.references  :stabilizer,           null: false, default: 0
      t.string   :stabilizer_sn
      t.references  :apc,                  null: false, default: 0
      t.string   :apc_sn
      t.references  :scaner,               null: false, default: 0
      t.string   :scaner_sn
      t.references  :bank_unit,             null: false, default: 0
      t.string   :terminal_sn
      t.references  :fiscal,               null: false, default: 0
      t.string   :fiscal_sn
      t.references  :organization_unit,     null: false, default: 0
      t.string   :comment
      t.integer  :cashbox_photos_id,       null: false, default: 0
      t.timestamps
    end
    add_index :cashboxes, :display_client_id
    add_index :cashboxes, :cashbox_photos_id
  end
end
