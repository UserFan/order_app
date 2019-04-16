class AddColumnServiceEquipment < ActiveRecord::Migration[5.1]
  def change
    add_column :service_equipments, :amount, :float,  default: 0.0, null: false 
  end
end
