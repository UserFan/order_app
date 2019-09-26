class CreateEnumAction < ActiveRecord::Migration[5.2]
  def change
    create_table :enum_actions do |t|
      t.string :name,           null: false, default: ""
      t.string :action_name,    null: false, default: ""
      t.timestamps
    end
  end
end
