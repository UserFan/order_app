class DeleteColumnToPerformers < ActiveRecord::Migration[5.1]
  def change
    remove_column :performers, :user_id, :integer
    remove_column :performers, :coexecutor, :integer
    remove_column :performers, :date_performance, :datetime
    remove_column :performers, :date_close_performance, :datetime
  end
end
