class CreateModem < ActiveRecord::Migration[5.1]
  def change
    create_table :modems do |t|
      t.string :name
      t.timestamps
    end
  end
end
