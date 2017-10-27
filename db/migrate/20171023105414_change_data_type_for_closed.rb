class ChangeDataTypeForClosed < ActiveRecord::Migration[5.1]
  def change
    change_table :shops do |t|
      t.change :closed, :datetime
    end
  end
end
