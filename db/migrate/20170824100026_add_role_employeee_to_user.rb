class AddRoleEmployeeeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee, :boolean, default: true
  end
end
