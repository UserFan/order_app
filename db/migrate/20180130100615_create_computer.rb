class CreateComputer < ActiveRecord::Migration[5.1]
  def change
    create_table :computers do |t|
      t.references  :shop,                    null: false, default: 0
      t.references  :display,                 null: false, default: 0
      t.string      :display_sn
      t.references  :system_unit,             null: false, default: 0
      t.string      :system_unit_sn
      t.references  :keyboard,                null: false, default: 0
      t.string      :keyboard_sn
      t.references  :commouse,                null: false, default: 0
      t.string      :commouse_sn
      t.references  :stabilizer,              null: false, default: 0
      t.string      :stabilizer_sn
      t.references  :printer,                 null: false, default: 0
      t.string      :printer_sn
      t.string      :teamview_id,             null: false, default: ""
      t.string      :ip_address,               null: false, default: ""
      t.string      :comment
      t.timestamps
    end
  end
end
