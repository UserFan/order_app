class CreatePerformer < ActiveRecord::Migration[5.1]
  def change
    create_table :performers do |t|
      t.references  :order,                     null: false, default: 0
      t.references  :user,                      null: false, default: 0
      t.datetime    :date_performance,          null: false
      t.datetime    :date_close_performance,    null: true
      t.boolean     :coexecutor,                default: false
      t.boolean     :message,                   default: false
      t.string      :comment
      t.timestamps
    end
  end
end
