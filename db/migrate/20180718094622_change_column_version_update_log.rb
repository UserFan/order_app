class ChangeColumnVersionUpdateLog < ActiveRecord::Migration[5.1]
  def change
    change_column_null :version_update_logs, :result_update, true
  end
end
