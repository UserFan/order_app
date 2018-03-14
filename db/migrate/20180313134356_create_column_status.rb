class CreateColumnStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :statuses, :role, :integer, array: true
  end
end
