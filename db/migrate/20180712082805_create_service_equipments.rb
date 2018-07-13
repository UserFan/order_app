class CreateServiceEquipments < ActiveRecord::Migration[5.1]
  def change
    create_table :service_equipments do |t|
      t.references  :shop,                  null: false, default: 0
      t.datetime :date_service,             null: false
      t.references  :equipment_type,        null: false,   default: 0
      t.string :description
      t.timestamps
    end
  end
end
