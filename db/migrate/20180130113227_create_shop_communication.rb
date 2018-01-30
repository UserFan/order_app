class CreateShopCommunication < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_communications do |t|
      t.references  :shop,                    null: false, default: 0
      t.references  :router,                 null: false, default: 0
      t.string      :router_sn
      t.timestamps
    end
  end
end
