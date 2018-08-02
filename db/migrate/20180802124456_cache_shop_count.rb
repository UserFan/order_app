class CacheShopCount < ActiveRecord::Migration[5.1]
  def change
    Shop.find_each do |shop|
      cashbox_count = Cashbox.where(shop_id: shop.id).size
      computer_count = Computer.where(shop_id: shop.id).size
      weighers_count = ShopWeigher.where(shop_id: shop.id).size
      shop_communication_count = ShopCommunication.where(shop_id: shop.id).size
      shop.update_attributes(cashboxes_count: cashbox_count,
                             computers_count: computer_count,
                             shop_weighers_count: weighers_count,
                             shop_communications_count: shop_communication_count
                             )
    end
  end
end
