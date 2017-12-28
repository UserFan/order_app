class CreateApc < ActiveRecord::Migration[5.1]
  def change
    create_table :apcs do |t|
      t.string :name
      t.timestamps
    end
  end
end
