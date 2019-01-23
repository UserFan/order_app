class AddColumnsToPerformers < ActiveRecord::Migration[5.1]
  def change
    add_reference :performers, :employee, default: 0, null: false, foreign_key: true
    add_column    :performers, :answerable, :boolean, default: false, null: false
    add_column    :performers, :deadline, :datetime,  null: false
  end
end
