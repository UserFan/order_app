class CreateEnumResource < ActiveRecord::Migration[5.2]
  def change
    create_table :enum_resources do |t|
      t.string     :name,             null: false, default: ""
      t.string     :resource_name,    null: false, default: ""
      t.references :enum_action,      default: 1, null: false, index: true
      t.timestamps
    end
  end
end
