class ChangeColumnPerformer < ActiveRecord::Migration[5.1]
  def change
    change_column_null :performers, :order_id, false
  end
end
