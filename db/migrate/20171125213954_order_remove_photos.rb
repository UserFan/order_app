class OrderRemovePhotos < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :photo
  end
end
