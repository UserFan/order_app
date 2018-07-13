class CreateEsps < ActiveRecord::Migration[5.1]
  def change
    create_table :esps do |t|
      t.references  :shop,           null: false, default: 0
      t.references  :carrier_type,   null: false, default: 0
      t.string :kpp
      t.timestamps
    end
  end
end
