class CreateActionApp < ActiveRecord::Migration[5.1]
  def change
    create_table :action_apps do |t|
      t.string :name,                  null: false, default: ""
      t.string :action_app_name,       null: false, default: ""      
    end
  end
end
