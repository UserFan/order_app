class RemoveColumnProfile < ActiveRecord::Migration[5.1]
  def change
    remove_column :profiles, :position_id
  end
end
