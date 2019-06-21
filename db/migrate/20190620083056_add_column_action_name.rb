class AddColumnActionName < ActiveRecord::Migration[5.1]
  def change
    add_reference :action_names, :action_app, default: 0, null: false, index: true
  end
end
