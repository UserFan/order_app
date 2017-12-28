class CreateRouter < ActiveRecord::Migration[5.1]
  def change
    create_table :routers do |t|
      t.string :name
      t.timestamps
    end
  end
end
