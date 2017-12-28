class CreateStabilizer < ActiveRecord::Migration[5.1]
  def change
    create_table :stabilizers do |t|
      t.string :name
      t.timestamps
    end
  end
end
