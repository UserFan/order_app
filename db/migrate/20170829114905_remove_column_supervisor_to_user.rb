class RemoveColumnSupervisorToUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :supervisor, :boolean
    remove_column :users, :manager, :boolean
    remove_column :users, :employee, :boolean
  end
end
