class CreateKeyboard < ActiveRecord::Migration[5.1]
  def change
    create_table :keyboards do |t|
      t.string :name
      t.timestamps
    end
  end
end
