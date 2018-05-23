class CreateSimCard < ActiveRecord::Migration[5.1]
  def change
    create_table :sim_cards do |t|
      t.string      :simphone_number,         default: ""
      t.string      :sim_number,              default: ""
      t.references  :provider,                null: false, default: 0
      t.string      :comment
      t.timestamps
    end
  end
end
