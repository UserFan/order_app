class DropMonitors < ActiveRecord::Migration[5.1]
  def change
    drop_table :monitors
  end
end
