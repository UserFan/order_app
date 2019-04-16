class AddColumnServiceEquipmentReportCostService < ActiveRecord::Migration[5.1]
  def change
    add_reference :service_equipments, :report_cost_service, default: 0, null: false, index: true
  end
end
