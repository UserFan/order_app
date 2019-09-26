class CreateTemplateAccess < ActiveRecord::Migration[5.2]
  def change
    create_table :template_accesses do |t|
      t.references :role,                 default: 0, null: false, index: true
      t.references :enum_resource,        default: 0, null: false, index: true
      t.references :user,                 default: 0, null: false, index: true
      t.references :enum_type_access,     default: 0, null: false, index: true
      t.string     :name,                 default: "", null: false
      t.timestamps
    end
  end
end
