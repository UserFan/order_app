class AddColumnOrderCounttoShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :order_count, :integer  
  end
end
