class CreateTask < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :type_document,        null: false, default: 0
      t.string :task_number,              null: false, default: ""
      t.references  :structural,          null: false, default: 0
      t.datetime :date_open,              null: false
      t.text :description,                null: false, default: ""
      t.datetime :date_execution,         null: false
      t.datetime :date_closed
      t.references :user,                 null: false, default: 0
      t.references :status,               null: false, default: 0
      t.jsonb :images_document
      t.timestamps
    end
  end
end
