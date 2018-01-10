class ChangeColumnShop < ActiveRecord::Migration[5.1]
  def change
    change_column_null :shops, :latitude, true
    change_column_null :shops, :longitude, true
  end
end
