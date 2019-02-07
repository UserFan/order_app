class CreateTaskPerformer < ActiveRecord::Migration[5.1]
  def change
    create_table :task_performers do |t|
      t.references  :task,                      null: false, default: 0
      t.references  :employee,                  null: false, default: 0
      t.datetime    :deadline,                  null: false
      t.boolean     :answerable,                default: false
      t.boolean     :message,                   default: true
      t.string      :comment
      t.timestamps
    end
  end
end
