class ChangeShopCommunicationCout < ActiveRecord::Migration[5.1]
  def change
    ShopCommunication.find_each do |communication|
      item_count = ItemCommunication.where(shop_communication_id: communication.id).size
      communication.update_attributes(item_communications_count: item_count)
    end
  end
end
