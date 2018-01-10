class ChangeColumnShop < ActiveRecord::Migration[5.1]
  def change
    change_column_null :shops, :latitude, false
    change_column_null :shops, :longitude, false
  end
end
