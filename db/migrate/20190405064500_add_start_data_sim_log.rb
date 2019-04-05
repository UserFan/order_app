class AddStartDataSimLog < ActiveRecord::Migration[5.1]
  def change
    if ItemCommunication.any?
      item_communications = ItemCommunication.all
      item_communications.each do |item|
        unless (item.sim_card_id.nil? && SimLog.where(sim_card_id: item.sim_card_id,
                                               shop_id: item.shop.id).present?)
          SimLog.create!(sim_card_id: item.sim_card_id, shop_id: item.shop.id,
                         date_start: item.created_at)
        end
      end
    end
  end
end
