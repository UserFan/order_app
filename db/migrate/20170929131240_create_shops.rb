class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shops do |t|
      t.string  :name,                null: false, default: ""
      t.string  :adress,              null: false, default: ""
      t.string  :gps,                 null: false, default: ""
      t.integer :type_id,             null: false, default: 0
      t.string  :photo
      t.integer :user_id,             null: false, default: 0
      t.timestamps
    end
    add_index :shops, :type_id
    add_index :shops, :user_id
  end
end
