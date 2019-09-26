class CreateEnumTypeEquipment < ActiveRecord::Migration[5.2]
  def change
    create_table :enum_type_equipments do |t|
      t.string :name,           null: false, default: ""
      t.timestamps
    end
  end
end
