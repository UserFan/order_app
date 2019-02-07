class CreateTypeDocument < ActiveRecord::Migration[5.1]
  def change
    create_table :type_documents do |t|
      t.string :name
      t.timestamps
    end
  end
end
