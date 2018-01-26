class CreateCashImages < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_images do |t|
      t.references  :cashbox,                 null: false, default: 0
      t.datetime    :date_add,                null: false
      t.jsonb       :images
      t.timestamps
    end
  end
end
