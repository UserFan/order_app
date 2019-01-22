class CreateColumnEmployeeToOrder < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :employee, foreign_key: true
  end
end
