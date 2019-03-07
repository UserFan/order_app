class AddColumnTaskExecution < ActiveRecord::Migration[5.1]
  def change
    add_column :task_executions, :manager_id, :integer,  default: 0, null: false
  end
end
