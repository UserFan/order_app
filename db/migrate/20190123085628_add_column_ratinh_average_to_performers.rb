class AddColumnRatinhAverageToPerformers < ActiveRecord::Migration[5.1]
  def change
    add_column :performers, :rating_average,     :integer,  default: 0, null: false
    add_column :performers, :hard_ratio_average, :integer,  default: 1, null: false
  end
end
