class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.references  :user,                  default: 0,  null: false
      t.string      :surname,               default: "", null: false
      t.string      :first_name,            default: "", null: false
      t.string      :middle_name,           default: "", null: true
      t.string      :avatar
      t.string      :mobile,                default: "", null: false
      t.references  :position,              default: 0,  null: false
      t.timestamps
    end
  end
end
