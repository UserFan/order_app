class CreateMouse < ActiveRecord::Migration[5.1]
  def change
    create_table :mice do |t|
      t.string :name
      t.timestamps
    end
  end
end
