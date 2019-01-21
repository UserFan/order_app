class DestroyColumnShortDescriptToOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :short_descript, :string    
  end
end
