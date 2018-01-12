class CreateBankUnit < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_units do |t|
      t.string :name
      t.timestamps
    end
  end
end
