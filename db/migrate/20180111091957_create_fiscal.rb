class CreateFiscal < ActiveRecord::Migration[5.1]
  def change
    create_table :fiscals do |t|
      t.string :name
      t.timestamps
    end
  end
end
