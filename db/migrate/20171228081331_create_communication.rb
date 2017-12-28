class CreateCommunication < ActiveRecord::Migration[5.1]
  def change
    create_table :communications do |t|
      t.string :name
      t.timestamps
    end
  end
end
