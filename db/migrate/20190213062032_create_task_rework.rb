class CreateTaskRework < ActiveRecord::Migration[5.1]
  def change
    create_table :task_reworks do |t|
      t.references  :task_execution,                null: false, default: 0
      t.references  :user,                          null: false, default: 0
      t.string      :comment,                       null: false, default: ""
      t.timestamps
    end
  end
end
