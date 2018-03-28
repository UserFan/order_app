class AddCollumnExecutions < ActiveRecord::Migration[5.1]
  def change
    add_column :executions, :complited, :datetime, null: true
  end
end
