class CreateActionName < ActiveRecord::Migration[5.1]
  def change
    create_table :action_names do |t|
      t.references :resource_name,     default: 0, null: false, index: true
      t.references :action_app,        default: 0, null: false, index: true
      t.timestamps
    end
  end
end
