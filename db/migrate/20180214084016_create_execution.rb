class CreateExecution < ActiveRecord::Migration[5.1]
  def change
    create_table :executions do |t|
      t.references  :performer,                     null: false, default: 0
      t.string      :comment,                       null: false, default: ""
      t.integer     :order_execution,               null: false, default: 0
      t.jsonb       :images
      t.timestamps
    end
  end
end
