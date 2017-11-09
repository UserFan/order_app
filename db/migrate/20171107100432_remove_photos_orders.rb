class RemovePhotosOrders < ActiveRecord::Migration[5.1]
  def change
      remove_column :orders, :photos
  end
end
