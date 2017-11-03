class RenameColumnControlOrder < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :control_id, :user_id
  end
end
