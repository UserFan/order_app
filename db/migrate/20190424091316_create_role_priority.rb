class CreateRolePriority < ActiveRecord::Migration[5.1]
  def change
    create_table :role_priorities do |t|
      t.references :template_role,         default: 0, null: false, index: true
      t.references :imageable,              polymorphic: true, index: true
      t.timestamps
    end
  end
end
