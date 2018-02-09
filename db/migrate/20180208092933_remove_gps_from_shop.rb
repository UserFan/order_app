class RemoveGpsFromShop < ActiveRecord::Migration[5.1]
  def change
    remove_column :shops, :gps, :string
  end
end
