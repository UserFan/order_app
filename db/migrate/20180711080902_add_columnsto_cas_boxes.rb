class AddColumnstoCasBoxes < ActiveRecord::Migration[5.1]
  def change
    add_column :cashboxes, :fiscal_fwversion, :string, default: ""
    add_column :cashboxes, :cash_set_version, :string, default: ""
    add_column :cashboxes, :ip_cash,          :string, default: ""
  end
end
