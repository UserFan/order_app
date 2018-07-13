class CreateCostEquipments < ActiveRecord::Migration[5.1]
  def change
    create_table :cost_equipments do |t|
      t.references  :shop,             null: false, default: 0
      t.datetime :date_cost,             null: false
      t.references  :cost_type,        null: false,   default: 0
      t.string :description
      t.timestamps
    end
  end
end
