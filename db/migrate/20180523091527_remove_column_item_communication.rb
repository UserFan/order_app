class RemoveColumnItemCommunication < ActiveRecord::Migration[5.1]
  def change
    remove_column :item_communications, :sim_number, :string
    remove_column :item_communications, :simphone_number, :string
  end
end
