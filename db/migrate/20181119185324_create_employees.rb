class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.references  :shop,                     null: false, default: 0
      t.references  :user,                     null: false, default: 0
      t.datetime    :work_start_date,          null: false
      t.datetime    :work_end_date
      t.boolean     :manager,                  null: false, default: false
      t.boolean     :temporary,                null: false, default: false
      t.references  :position,                 null: false, default: 0
      t.timestamps
    end
  end
end
