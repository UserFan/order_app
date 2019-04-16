class CreateReportCostService < ActiveRecord::Migration[5.1]
  def change
    create_table :report_cost_services do |t|
      t.datetime    :date_report,                   null: false
      t.references  :status,                        null: false, default: 0
      t.string      :comment,                       null: false, default: ""
      t.timestamps
    end
  end
end
