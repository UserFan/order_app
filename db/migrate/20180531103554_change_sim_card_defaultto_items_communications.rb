class ChangeSimCardDefaulttoItemsCommunications < ActiveRecord::Migration[5.1]
  def change
    change_column_default :item_communications, :sim_card_id, nil    
  end
end
