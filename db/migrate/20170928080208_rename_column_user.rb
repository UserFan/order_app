class RenameColumnUser < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.rename :role, :role_id
      t.rename :position, :position_id
    end
  end
end
