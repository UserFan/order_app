class AddColumnClosedToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :closed, :date
  end
end
