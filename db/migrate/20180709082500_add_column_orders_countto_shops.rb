class AddColumnOrdersCounttoShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :orders_count, :integer, default: 0
  end
end
