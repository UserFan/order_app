class CreateMonitors < ActiveRecord::Migration[5.1]
  def change
    create_table :monitors do |t|
      t.string :name
      t.timestamps
    end
  end
end
