class AddColumnReportCostService < ActiveRecord::Migration[5.1]
  def change
    add_column :report_cost_services, :name_report, :string, default: "", null: false
  end
end
