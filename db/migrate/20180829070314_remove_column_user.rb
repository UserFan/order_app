class RemoveColumnUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :full_name, :string
    remove_column :users, :mobile, :string
    remove_column :users, :avatar, :string
    remove_column :users, :position_id, :integer
  end
end
