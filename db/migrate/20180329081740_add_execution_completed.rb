class AddExecutionCompleted < ActiveRecord::Migration[5.1]
  def change
    add_column :executions, :completed, :datetime, null: true
  end
end
