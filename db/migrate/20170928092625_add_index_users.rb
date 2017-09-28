class AddIndexUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :position_id
    add_index :users, :role_id
  end
end
