class AddDateExecutionToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :date_execution, :datetime
  end
end
