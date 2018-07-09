class AddColumnOrdersandShopsCounttoUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :orders_count, :integer, default: 0
    add_column :users, :shops_count, :integer, default: 0
  end
end
