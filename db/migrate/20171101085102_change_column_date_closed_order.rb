class ChangeColumnDateClosedOrder < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:orders, :date_closed, true )
  end
end
