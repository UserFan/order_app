class CreateSimLog < ActiveRecord::Migration[5.1]
  def change
    create_table :sim_logs do |t|
      t.references  :sim_card,                      null: false, default: 0
      t.references  :shop,                          null: false, default: 0
      t.datetime    :date_start,                    null: false
      t.datetime    :date_end
      t.string      :comment,                       null: false, default: ""
      t.timestamps
    end
  end
end
