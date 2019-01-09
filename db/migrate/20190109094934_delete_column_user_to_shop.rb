class DeleteColumnUserToShop < ActiveRecord::Migration[5.1]
  def change
    remove_column :shops, :user_id, :integer
  end
end
