class CreateTemplateRole < ActiveRecord::Migration[5.1]
  def change
    create_table :template_roles do |t|
      t.references :role,                 default: 0, null: false, index: true
      t.references :action_name,          default: 0, null: false, index: true
      t.integer    :type_access,          default: 0, null: false
      t.string     :name,                 default: "", null: false
      t.timestamps
    end
  end
end
