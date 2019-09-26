class CreateEnumEquipment < ActiveRecord::Migration[5.2]
  def change
    create_table :enum_equipments do |t|
      t.string :make_name,                 null: false, default: ""
      t.references :enum_type_equipment,   default: 1, null: false, index: true
      t.string :serial_number,             default: ""
      t.string :qr_code,                   default: ""
      t.text :feature,                     default: ""
      t.jsonb :image_equipment
      t.timestamps
    end
  end
end
