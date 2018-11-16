class AddColumnStructurialUnitToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :structural_unit, :boolean, default: false
  end
end
