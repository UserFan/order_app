class RenameColumnOrder < ActiveRecord::Migration[5.1]
  def change
   rename_column :orders, :categories_id, :category_id
   rename_column :orders, :shops_id, :shop_id
  end
end
