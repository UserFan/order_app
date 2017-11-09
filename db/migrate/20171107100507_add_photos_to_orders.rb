class AddPhotosToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :photos, :jsonb
  end
end
