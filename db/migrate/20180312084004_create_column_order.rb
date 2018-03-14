class CreateColumnOrder < ActiveRecord::Migration[5.1]
  def change
     add_column :orders, :order_number, :string, null: false, default: ""
  end
end
