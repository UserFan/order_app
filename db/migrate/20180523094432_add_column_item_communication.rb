class AddColumnItemCommunication < ActiveRecord::Migration[5.1]
  def change
    add_reference :item_communications, :sim_card, foreign_key: true
  end
end
