class CreateSystemUnit < ActiveRecord::Migration[5.1]
  def change
    create_table :system_units do |t|
      t.string  :cpu
      t.string  :ram
      t.string  :motherboard
      t.string  :hdd
      t.boolean :lan,                 null: false, default: false
      t.boolean :wifi,                null: false, default: false
      t.timestamps
    end
  end
end
