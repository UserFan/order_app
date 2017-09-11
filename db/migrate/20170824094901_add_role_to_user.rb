class AddRoleToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :supervisor, :boolean, default: false
    add_column :users, :manager, :boolean, default: false
  end
end
