class ChangeColumnSystemUnit < ActiveRecord::Migration[5.1]
  def change
    add_column :system_units, :name, :string
    add_column :system_units, :os, :string
    remove_column :system_units, :lan
    remove_column :system_units, :wifi
  end
end
