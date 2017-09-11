class RemoveColumnAdminToUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :Admin, :boolean
  end
end
