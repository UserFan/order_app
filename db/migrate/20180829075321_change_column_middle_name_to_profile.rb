class ChangeColumnMiddleNameToProfile < ActiveRecord::Migration[5.1]
  def change
    change_column_null :profiles, :middle_name, true
  end
end
