class CreateResourceName < ActiveRecord::Migration[5.1]
  def change
    create_table :resource_names do |t|
      t.string :name,               null: false, default: ""
      t.string :table_name,         null: false, default: ""
      t.timestamps
    end
  end
end
