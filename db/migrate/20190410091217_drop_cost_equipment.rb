class DropCostEquipment < ActiveRecord::Migration[5.1]
  def change
    drop_table :cost_equipments
  end
end
