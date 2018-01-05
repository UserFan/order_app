class CreateDisplay < ActiveRecord::Migration[5.1]
  def change
    create_table :displays do |t|
      t.string :name
    end
  end
end
