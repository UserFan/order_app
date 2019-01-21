class AddColumnOwnerToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :answerable_manager, :integer, default: 0, null: false
    add_index :orders, :answerable_manager  
  end
end
