class CreateScales < ActiveRecord::Migration[5.1]
  def change
    create_table :scaleses do |t|
      t.string :name
      t.timestamps
    end
  end
end
