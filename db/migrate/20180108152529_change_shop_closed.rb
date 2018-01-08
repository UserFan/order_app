class ChangeShopClosed < ActiveRecord::Migration[5.1]
  def change
    change_column_null :shops, :closed, true
  end
end
