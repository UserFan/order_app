class CreateScaner < ActiveRecord::Migration[5.1]
  def change
    create_table :scaners do |t|
      t.string :name
      t.timestamps
    end
  end
end
