class CreateShopWeigher < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_weighers do |t|
      t.references  :shop,                 null: false, default: 0
      t.references  :weigher,              null: false, default: 0
      t.string      :weigher_sn
      t.string      :ip_address,           null: false, default: ""
      t.string      :comment
      t.timestamps
    end
  end
end
