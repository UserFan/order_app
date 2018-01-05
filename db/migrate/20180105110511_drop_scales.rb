class DropScales < ActiveRecord::Migration[5.1]
  def change
    drop_table :scales
  end
end
