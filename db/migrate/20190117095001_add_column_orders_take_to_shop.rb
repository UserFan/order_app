class AddColumnOrdersTakeToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :orders_take, :boolean, default: false
  end
end
