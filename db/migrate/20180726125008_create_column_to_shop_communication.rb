class CreateColumnToShopCommunication < ActiveRecord::Migration[5.1]
  def change
    add_column :shop_communications, :item_communications_count, :integer, default: 0
  end
end
