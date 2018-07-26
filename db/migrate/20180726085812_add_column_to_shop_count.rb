class AddColumnToShopCount < ActiveRecord::Migration[5.1]

  def change
    add_column :shops, :cashboxes_count, :integer, default: 0
    add_column :shops, :computers_count, :integer, default: 0
    add_column :shops, :shop_weighers_count, :integer, default: 0
    add_column :shops, :shop_communications_count, :integer, default: 0
  end   

end
