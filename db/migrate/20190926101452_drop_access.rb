class DropAccess < ActiveRecord::Migration[5.2]
  def change
    drop_table :action_apps
    drop_table :template_roles
    drop_table :role_priorities
    drop_table :action_names
    drop_table :resource_names
  end
end
