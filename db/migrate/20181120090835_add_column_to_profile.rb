class AddColumnToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :date_recruitment, :datetime
    add_column :profiles, :date_quit, :datetime
  end
end
