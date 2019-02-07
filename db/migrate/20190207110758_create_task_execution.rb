class CreateTaskExecution < ActiveRecord::Migration[5.1]
  def change
    create_table :task_executions do |t|
      t.references  :task_performer,                null: false, default: 0
      t.string      :comment,                       null: false, default: ""
      t.integer     :task_execution,                null: false, default: 0
      t.datetime    :completed,                     null: true
      t.jsonb       :images_document
      t.timestamps
    end
  end
end
