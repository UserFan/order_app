class AddColumnSimCard < ActiveRecord::Migration[5.1]
  def change
    add_column :sim_cards, :traffic, :integer,  default: 0, null: false
    add_column :sim_cards, :update_traffic, :datetime    
  end
end
