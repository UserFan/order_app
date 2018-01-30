class CreateItemCommunication < ActiveRecord::Migration[5.1]
  def change
    create_table :item_communications do |t|
      t.references  :shop_communication,      null: false, default: 0
      t.references  :communication,           null: false, default: 0
      t.references  :provider,                null: false, default: 0
      t.references  :modem,                   default: 0
      t.string      :modem_sn
      t.boolean     :master,                  default: false
      t.string      :simphone_number,         default: ""
      t.string      :sim_number,              default: ""
      t.string      :login_name,              default: ""
      t.string      :pass_name,               default: ""
      t.string      :comment
      t.timestamps
    end
  end
end
