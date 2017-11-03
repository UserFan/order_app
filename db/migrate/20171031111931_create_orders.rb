class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :categories_id,              null: false, default: 0
      t.datetime :date_open,                 null: false
      t.integer :shops_id,                   null: false, default: 0
      t.string :short_descript,              null: false, default: ""
      t.text :description
      t.datetime :date_closed,               null: false
      t.string  :photo
      t.integer :control_id,                 null: false, default: 0
      t.integer :status_id,                  null: false, default: 0
      t.timestamps
    end
    add_index :orders, :categories_id
    add_index :orders, :shops_id
    add_index :orders, :control_id
    add_index :orders, :status_id
  end
end
